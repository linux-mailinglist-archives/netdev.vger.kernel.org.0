Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F34130F9C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfEaOFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:05:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51772 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfEaOFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:05:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id f10so6157256wmb.1
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 07:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UmNVHSUFcwKieLoDgVxZZ6h5wY64iIjCWDKB455Gdsk=;
        b=CcuEzc5aqSSKNO2PQOJj8mdppWKokLEoitOFAaqAsNOhA5YCdWilKx9LTP/oxcd0dU
         iTMFmr9yknRzmq4zkArnH3aAfgYlysDknVJE1LRFgpR+jXy7akXAXTg/SrvxPrbhjaWE
         YjHrUZIARJ0ihploRiFBi1F15FWFEhgyVnolcyN5x612F2b/iJdR/nGDJmEzwAbSxP2a
         tfU9FgXT8BcdC0Jqj63b+dB4dc1CC/gqTxfgLVowINE2E6JXXWbg7k2nhP249BIqvgM5
         wCBqCdmlulM2UC4OF8fNnBpKARvo4Lsxh4t9tYXKKe1URsnF0fmoB9KXekstBJGCkxwg
         7g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UmNVHSUFcwKieLoDgVxZZ6h5wY64iIjCWDKB455Gdsk=;
        b=c845j7lqJyHmETBVLCHYUIPEhkoKmrVTMJY7d+fhJCLq4p5SbrL2Fpy+17PawusGvU
         ZFMewZ6wjk7c3wTzU8fthxUQ96ogFicB+0onjeurmy1o/QekbAuRapdFOs38ZAGuaJRg
         YaE6guQPX0h/NInGJNyAcDX8pm7EpQhgoPJ6/lfXFFY7II5P6CZcon/+WivDdKVSurpT
         oeutixQrAkgH+d49/Vdma1aqH+xFX1xjhhaSrkJKEIa9qK6MPEsjp7OP3AVDSwRvhH5o
         Z2x499o3LJdCNWiDo/N0viyn9C/xrQnEYd3tMPIA8WHVFcRTA6HUbblvcOKj5RLJryGG
         kO4w==
X-Gm-Message-State: APjAAAUR9jIq3SbskeoeYRzhLavGxuoKd+M4XWRXHHsscJVhPu+bCdZ6
        oe4ZVhmfO1B4SWdqzRR5L18=
X-Google-Smtp-Source: APXvYqz/CvJjgpFekb6P5YDKWjiid37tH1P45AcIU4eKwfKipeM40tdnnlMfNiy/Ifjpc4HQRU9cBQ==
X-Received: by 2002:a1c:7408:: with SMTP id p8mr5695563wmc.161.1559311537019;
        Fri, 31 May 2019 07:05:37 -0700 (PDT)
Received: from AHABDELS-M-J3JG ([192.135.27.139])
        by smtp.gmail.com with ESMTPSA id k2sm9886034wrg.41.2019.05.31.07.05.36
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 31 May 2019 07:05:36 -0700 (PDT)
Date:   Fri, 31 May 2019 16:05:35 +0200
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH net-next 6/6] seg6: Add support to rearrange SRH for AH
 ICV calculation
Message-Id: <20190531160535.519fdef1067aa9d681669d29@gmail.com>
In-Reply-To: <1559253021-16772-7-git-send-email-tom@quantonium.net>
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
        <1559253021-16772-7-git-send-email-tom@quantonium.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 14:50:21 -0700
Tom Herbert <tom@herbertland.com> wrote:

> Mutable fields related to segment routing are: destination address,
> segments left, and modifiable TLVs (those whose high order bit is set).
> 
> Add support to rearrange a segment routing (type 4) routing header to
> handle these mutability requirements. This is described in
> draft-herbert-ipv6-srh-ah-00.
> 

Hi Tom, David,
I think it is very early to have such implementation in the mainline of the Linux kernel.
The draft (draft-herbert-ipv6-srh-ah-00) has been submitted to IETF draft couple of days ago. 
We should give the IETF community the time to review and reach a consensus on this draft.
Thanks, 
Ahmed

-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
