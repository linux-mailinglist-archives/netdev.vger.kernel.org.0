Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542ED55D04E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbiF0Q6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbiF0Q6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:58:10 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58ADDEB;
        Mon, 27 Jun 2022 09:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656349089; x=1687885089;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y6XvG9/U51igKius4IaKDqx8Gy6lPi0Xal5PaG7hwgI=;
  b=J/AQW9HsiF4+Dxkq+zNvWJ9js8k1koNJ1aYuSdCZaUc9DyZwy4DitiYN
   OKbPd7JaYfrNNxFnH7Vwa3RlkUtvlPvKf0vyG0ezyJ9bB1bXdFL+Tqy5v
   49e/3XurHHxhYiBsP8R5gLer9bFX5Z6NjaG+x8uJ0HRFEKQEJqL8h9aow
   c=;
X-IronPort-AV: E=Sophos;i="5.92,226,1650931200"; 
   d="scan'208";a="102367407"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 27 Jun 2022 16:36:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 7A9C4A2BB3;
        Mon, 27 Jun 2022 16:36:52 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 16:36:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.124) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 27 Jun 2022 16:36:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <sachinp@linux.ibm.com>
CC:     <davem@davemloft.net>, <kuniyu@amazon.com>,
        <linux-next@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <netdev@vger.kernel.org>
Subject: Re: [powerpc] Fingerprint systemd service fails to start (next-20220624)
Date:   Mon, 27 Jun 2022 09:36:40 -0700
Message-ID: <20220627163640.74890-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <B2AA3091-796D-475E-9A11-0021996E1C00@linux.ibm.com>
References: <B2AA3091-796D-475E-9A11-0021996E1C00@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D07UWB001.ant.amazon.com (10.43.161.238) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sachin,
Thanks for the report.

From:   Sachin Sant <sachinp@linux.ibm.com>
Date:   Mon, 27 Jun 2022 10:28:27 +0530
> With the latest -next I have observed a peculiar issue on IBM Power
> server running -next(5.19.0-rc3-next-20220624) .
> 
> Fingerprint authentication systemd service (fprintd) fails to start while
> attempting OS login after kernel boot. There is a visible delay of 18-20
> seconds before being prompted for OS login password.
> 
> Kernel 5.19.0-rc3-next-20220624 on an ppc64le
> 
> ltcden8-lp6 login: root
> <<=======.  delay of 18-20 seconds
> Password: 
> 
> Following messages(fprintd service) are seen in /var/log/messages:
> 
> systemd[1]: Startup finished in 1.842s (kernel) + 1.466s (initrd) + 29.230s (userspace) = 32.540s.

It seems the kernel finishes its job immediately but userspace takes more
time on retrying or something.  The service_start_timeout seems to be the
timeout period.


> NetworkManager[1100]: <info>  [1656304146.6686] manager: startup complete
> dbus-daemon[1027]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service' requested by ':1.21' (uid=0 pid=1502 comm="/bin/login -p --      ")
> systemd[1]: Starting Fingerprint Authentication Daemon...
> fprintd[2521]: (fprintd:2521): fprintd-WARNING **: 00:29:08.568: Failed to open connection to bus: Could not connect: Connection refused

I think this message comes from here.
https://github.com/freedesktop/libfprint-fprintd/blob/master/src/main.c#L183-L189

I'm not sure what the program does though, I guess it failed to find a peer
socket in the hash table while calling connect()/sendmsg() syscalls and got
-ECONNREFUSED in unix_find_bsd() or unix_find_abstract().


> systemd[1]: fprintd.service: Main process exited, code=exited, status=1/FAILURE
> systemd[1]: fprintd.service: Failed with result 'exit-code'.
> systemd[1]: Failed to start Fingerprint Authentication Daemon.
> dbus-daemon[1027]: [system] Failed to activate service 'net.reactivated.Fprint': timed out (service_start_timeout=25000ms)
> 
> Mainline (5.19.0-rc3) or older -next does not have this problem.
> 
> Git bisect between mainline & -next points to the following patch:
> 
> # git bisect bad
> cf2f225e2653734e66e91c09e1cbe004bfd3d4a7 is the first bad commit
> commit cf2f225e2653734e66e91c09e1cbe004bfd3d4a7
> 
> Date:   Tue Jun 21 10:19:12 2022 -0700
> 
>     af_unix: Put a socket into a per-netns hash table.
> 
> I don’t know how the above identified patch is related to the failure,
> but given that I can consistently recreate the issue assume the bisect
> result can be trusted.

Before the commit, all of sockets on the host are linked in a global hash
table, and after the commit, they are linked in their network namespace's
hash table.  So, I believe there is no change visible to userspace.


> I have attached dmesg log for reference. Let me know if any additional
> Information is required.

* Could you provide
  * dmesg and /var/log/messages on a successful case? (without the commit)
  * Unit file
  * repro steps

* Is it reproducible after login? (e.g. systemctl restart)
  * If so, please provide
    * the result of strace -t -ff

* Does it happen on only powerpc? How about x86 or arm64?

* What does the service does?
  * connect() or sendmsg()
  * protocol family
  * abstract or BSD socket

Best regards,
Kuniyuki

