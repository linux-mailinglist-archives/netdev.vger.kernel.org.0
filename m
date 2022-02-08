Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775064AE5B7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbiBHX7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 18:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239065AbiBHX7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 18:59:39 -0500
X-Greylist: delayed 497 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 15:59:38 PST
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DA2C061577
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 15:59:38 -0800 (PST)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 936DB2E086
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 23:51:21 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.133])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 782492007E;
        Tue,  8 Feb 2022 23:51:18 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4C494B00061;
        Tue,  8 Feb 2022 23:51:18 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 9C48F13C2B3;
        Tue,  8 Feb 2022 15:51:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 9C48F13C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1644364277;
        bh=XFVFyATlGLLSGcdSqpORYKjykLbo6TZfm4vyE7ruVQk=;
        h=To:Cc:From:Subject:Date:From;
        b=eWoCLMpiopyxcIKeRGzggmP2uPlT/udm9k+NPZXuC2fSxqUs7F08T0Vkxc3hWjqp7
         6rP00d36kZYeOR//iBDtiA1RFon0JjgqYzIL58Bzq0OoQK8q00xz6rbMH7LViVoupz
         ndaJt8nfZB2HocaE5RwvVggi0uv3YJ15kNk+Y60g=
To:     Salam Noureddine <noureddine@arista.com>
Cc:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Question on comment in dev_queue_xmit_nit
Organization: Candela Technologies
Message-ID: <40bf4696-2c58-f5ba-e81f-46a2a5e7887a@candelatech.com>
Date:   Tue, 8 Feb 2022 15:51:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1644364278-csaKAfhob4Lw
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Salam,

After an 8 day torture test on a hacked 5.15.7+ kernel doing wifi testing, our system crashed
in the dev_queue_xmit_nit method, evidently 'skb' is NULL.

gdb claims it is the 'skb2 = skb_clone ...' line below.  Now, this crash could
be fault of my local patches or other random things, but the comment caught
my attention.  It is cloning once per loop as far as I can see, so why the comment
about 'done only once' ?

		/* need to clone skb, done only once */
		skb2 = skb_clone(skb, GFP_ATOMIC);
		if (!skb2)
			goto out_unlock;

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

