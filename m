Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0D149AB7
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgAZNUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:20:10 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46317 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgAZNUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:20:10 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so2755224pll.13;
        Sun, 26 Jan 2020 05:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qFmJ85cJ5bHzMdd9PJDJanoJBeSPOYAKuu6B3Rz+8MM=;
        b=sg/LGHubq6c/mDNUpzqbD8QV2utRz/c9y9JORPN8efDE7Cy+B3wTrboQ2dNY1zBtag
         ybOH+kaKgMgpYfNVca3MAm0QH95XD5wlz67NpIoz2SBCYqcwUp/67+9673o+QQaQrONt
         70hmci5GklichLAS2rMJRJceIZYrBzwmyLTZ21TgAYdwxgkgaDZUtWJiJ+eczLwKexyt
         tmRpn5weTVZfI4ZyWlYpNSJfpoS9At2R2zTZX/z9jUCMcBOp38DMLVTOQQKgRiKN7S3d
         DG8MdfYac57FsU/Ukp+u78bG1Ck66zVjYDfyFnMJm1Rf86V9xzWnc2MLj2LHhNgiXH+q
         RLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=qFmJ85cJ5bHzMdd9PJDJanoJBeSPOYAKuu6B3Rz+8MM=;
        b=K+8ZVOid76dzWHovQmoBiqetcFfxfdrDS090NsoZECsghw7lJMcK5/6bvliiEShpkS
         LIybmzChShXkrKh/9ncISNExAIVDOT7cUyMkQZfdrdfZ+eSDwoOBIEW+LnC1f0Vv4Bjd
         9sjILjQEOQXcBEQZ0st1hcez2UDImeFRfHnkyhtsVmkwc23L4XnnAUce9UCo4QMBERwV
         52E3IeDxwKfLhja0SRVmKw1rs5/bmFasDgvWNY7p2m+T8x2lQ1fGpPgy61f/2JMSPqPt
         gr6TLbRuShKaYdFLdgsPKMP95ycT9Vs0lbAm0wU+ZVZ1KtqjjQDAWjt1dkDCcmMYKD2v
         iW6Q==
X-Gm-Message-State: APjAAAXGzyVTw4QEtU1l3c4DtEYSmcNZ8h2vyRNNsmgq1SMFEFbSZRkK
        4+LVKlvFKs3NAuiHDEodbs8=
X-Google-Smtp-Source: APXvYqxQM1UdwS3WSmnegLNDPNTmtELKNbZOjJl1nL6NITYEQKMPaZBzC5aS/EJAiw5NfjIcgBMLqg==
X-Received: by 2002:a17:902:bd90:: with SMTP id q16mr406108pls.34.1580044808979;
        Sun, 26 Jan 2020 05:20:08 -0800 (PST)
Received: from localhost ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id m22sm13169639pgn.8.2020.01.26.05.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 05:20:08 -0800 (PST)
Date:   Sun, 26 Jan 2020 15:20:04 +0200
From:   Johan Hedberg <johan.hedberg@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        syzbot <syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] Bluetooth: Fix race condition in hci_release_sock()
Message-ID: <20200126132004.GA70786@pmessmer-mobl1.ger.corp.intel.com>
Mail-Followup-To: Dan Carpenter <dan.carpenter@oracle.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        syzbot <syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000012309d059c27b724@google.com>
 <20200115174903.shuanlfvnly3anqk@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115174903.shuanlfvnly3anqk@kili.mountain>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Wed, Jan 15, 2020, Dan Carpenter wrote:
> Syzbot managed to trigger a use after free "KASAN: use-after-free Write
> in hci_sock_bind".  I have reviewed the code manually and one possibly
> cause I have found is that we are not holding lock_sock(sk) when we do
> the hci_dev_put(hdev) in hci_sock_release().  My theory is that the bind
> and the release are racing against each other which results in this use
> after free.
> 
> Reported-by: syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Not tested!  Please review very very carefully!
> 
> I feel like maybe someone should audit the (struct proto_ops)->release()
> functions because there may be similar bugs to this in other drivers.
> 
>  net/bluetooth/hci_sock.c | 3 +++
>  1 file changed, 3 insertions(+)

The patch looks correct to me since it's following the same locking
conventions as all the other socket callbacks in hci_sock.c. I also
verified that it doesn't cause regressions in the various socket testers
we have in user space BlueZ (e.g. tools/l2cap-tester). The patch is now
applied to the bluetooth-next tree. Thanks!

Johan
