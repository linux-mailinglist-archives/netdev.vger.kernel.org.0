Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87023107AA4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKVWgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:36:36 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33031 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfKVWgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 17:36:36 -0500
Received: by mail-lf1-f65.google.com with SMTP id d6so6723109lfc.0
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 14:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EJ2q+98hIgbtpF1bykn6H0JzvuLahtvUPAIRfPA4bpw=;
        b=Oe9HTTrOd3NBNUZIihAd0Fk78oEwbvx7aPQiSyijVTXR5RNzjhfQCCaZ0G9kQudswh
         aY+L+A33PNrrVsCGias8QEx9jHoRy74ezigtG+d+s3P9ao63J+QBlIc+qtU18Bq27H7J
         qd09BgIZZIUTSyW2GBB4z7uLI7fWxX9mZ3tt7PQYvF3p3oi+6BzaNCO2x372HE8ZwOR9
         gKAu1gxNyeKYEMsgcUGjoiBVgH558b2apybHNw87lc0+PmaR3Xvk/84VdzEDYnV4YGUh
         WLASaaGjuEPzaKJWA3dAtWfvghtxEER+m4IQyZqaLRiun0BLdWM48b33dYCcf1EqGEyo
         DU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EJ2q+98hIgbtpF1bykn6H0JzvuLahtvUPAIRfPA4bpw=;
        b=ryLdjJpPxnk25GX7KWcMhHECl0Q/leXQBQoTicOOSSeCwaPF6FWjlMyMtFOAGD0VTu
         gJuvNmDnbHlA3aIKyTt/8AYNoH0TYCULXrT5RAI9k36iWZ8aRLeAP2b5JpCliWyuX3Rq
         6WvTi5raO5FescvNmwzIdSz189p5WE2WPSbb6xL3d79PJz+vJZEPIW7AXPeCp+cQYlw2
         5gXJdUCFitvwzRuPcER3yl71prPbgPbHjCsXg90xrVH7ZISVSRQA2VR8OW334D6yTEij
         mR9kOuYUnKuesWf0eqIxtZCgP4uwjZmsF123QF5XIOXZ38szanq95xBklFYmD9mEHwb6
         wTOA==
X-Gm-Message-State: APjAAAVmEalWrCK3s+7GAc6Re6bPMXOjP5ymeUlbPJq7cyR3WhP0v60U
        Vu6E06Ikq2KT0TXFkb47poi2PA==
X-Google-Smtp-Source: APXvYqytzabgUCMUaoorkLdemEKAFSC4Edam6mgXaEJfVoJ5J6mhUoR6efXkZ8Pi5h9QVNSCI2fhsQ==
X-Received: by 2002:a19:5f44:: with SMTP id a4mr12731756lfj.45.1574462192805;
        Fri, 22 Nov 2019 14:36:32 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c19sm3527078ljj.61.2019.11.22.14.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 14:36:32 -0800 (PST)
Date:   Fri, 22 Nov 2019 14:36:24 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, daniel@iogearbox.net
Cc:     borisp@mellanox.com, aviadye@mellanox.com, netdev@vger.kernel.org,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
Subject: Re: [RFC net] net/tls: clear SG markings on encryption error
Message-ID: <20191122143624.5b82b1d0@cakuba.netronome.com>
In-Reply-To: <20191122214553.20982-1-jakub.kicinski@netronome.com>
References: <20191122214553.20982-1-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 13:45:53 -0800, Jakub Kicinski wrote:
> Also there's at least one more bug in this piece of code, TLS 1.3
> can't assume there's at least one free SG entry.

And I don't see any place where the front and back of the SG circular
buffer are actually chained :( This:

static inline void sk_msg_init(struct sk_msg *msg)
{
	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
	memset(msg, 0, sizeof(*msg));
	sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
}

looks questionable as well, we shouldn't mark MAX_MSG_FRAGS as the end,
we don't know where the end is going to be..

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 6cb077b646a5..6c6ce6f90e7d 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -173,9 +173,8 @@ static inline void sk_msg_clear_meta(struct sk_msg *msg)
 
 static inline void sk_msg_init(struct sk_msg *msg)
 {
-       BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != MAX_MSG_FRAGS);
        memset(msg, 0, sizeof(*msg));
-       sg_init_marker(msg->sg.data, MAX_MSG_FRAGS);
+       sg_chain(msg->sg.data, ARRAY_SIZE(msg->sg.data), msg->sg.data);
 }
 
 static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,

Hm?
