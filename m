Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB1B21F2D7
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGNNlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:41:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56401 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726929AbgGNNlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594734105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4Plj9PfUi2DeyVprMWl3dCa4CGzKbm/4lsd0XiSja4=;
        b=Bcwu71balzmXhR8NHkAJdwaS9tDSiZh7xEn0KmfaD0V+rFRq43KCpYzly1hEK8cu6A/NYS
        CFEeoHsqjMIaNEvUTzaHdPfxm8E234E27pc4mgEk9zPmjAMx6+7QtqefF1Hf7PwH6WtdBF
        nzbda/YpScImoIaJtBFkjYsKPwHkbBQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-HfmGQK-1OxOkABcoOEQEOw-1; Tue, 14 Jul 2020 09:41:41 -0400
X-MC-Unique: HfmGQK-1OxOkABcoOEQEOw-1
Received: by mail-qv1-f70.google.com with SMTP id v20so9660834qvt.15
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4Plj9PfUi2DeyVprMWl3dCa4CGzKbm/4lsd0XiSja4=;
        b=ZTXbwFCRkRd1uPATFqtEIvuNeQYSb4qafmuXCjuEo4l06FHC/QUj7SwINS5QV7lIbo
         3ORJWzoAPLSxEmg5cajQwrrr808tM2F6L2XckYL8s20s84wkIQ7VR4ILldL6pvM6+jc+
         0ZOsprf5gRxvlEsJhTdo3CzDLokzQTDSoLUFAESJ4yLp2il/914RKjJTtLA3cHV++5vv
         grLTWcQ1d+dxchzB/uU6xAh6HgqK3IDWrY4pYSMXA/F5xZCpoQUof80lynbnanRvlstN
         fLP70RB68CBWsDM7QUMWwE5wie/P0tgPtLJMozn5Pli4UXrOUMRmT2Itg99Lqh6yMkoF
         rCyw==
X-Gm-Message-State: AOAM532r/669j0dSkn0FDmBf4cM3xFSGYS0utzRoZd8hR0KmfpJ+blpG
        taPFyb4EBnLZw3GXQqtDH3yaRKr4zDgneCEQ/CKjlIyNzGr69U9Nf8iHab3+1/R1s1XIvwbgu9H
        tHK8VC58BUh/Q/soL
X-Received: by 2002:a37:aa10:: with SMTP id t16mr4272913qke.422.1594734101038;
        Tue, 14 Jul 2020 06:41:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziG2YbOKFb2g0BJJyzZfVgAajsdjdGVHFoN/bKmwEZB4C2JhP+jIFzo2beCbsMKrbWZe6fsg==
X-Received: by 2002:a37:aa10:: with SMTP id t16mr4272886qke.422.1594734100740;
        Tue, 14 Jul 2020 06:41:40 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id i57sm25362566qte.75.2020.07.14.06.41.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:41:39 -0700 (PDT)
Message-ID: <92deedd5d128361947b1381a1309606c67d082e6.camel@redhat.com>
Subject: Re: [PATCH] iscsi: qedi (qed_int.c) disable "MFW indication via
 attention" SPAM every 5 minutes
From:   Laurence Oberman <loberman@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com,
        netdev@vger.kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com
Date:   Tue, 14 Jul 2020 09:41:37 -0400
In-Reply-To: <20200713.175825.1534786004215530376.davem@davemloft.net>
References: <1594674941-32092-1-git-send-email-loberman@redhat.com>
         <20200713.175825.1534786004215530376.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-13 at 17:58 -0700, David Miller wrote:
> From: Laurence Oberman <loberman@redhat.com>
> Date: Mon, 13 Jul 2020 17:15:41 -0400
> 
> > This is likely firmware causing this but its starting to annoy
> customers.
> > Change the message level to verbose to prevent the spam.
> > 
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> 
> "iscsi:" doesn't belong in this Subject line.
> 
> Please look at recent changes to this driver and what commit header
> line subsystem prefixes and layout is being used.
> 
> Thanks.
> 

Hi Dave, I will resend.
The challenge is that while the proposed fix is in qed_int.c it only
manifests when the ISCSI persinality is enabled on the card.

I will set as appropriate header but mention the qedi ISCSI connection
in the V2 of this patch.

Thanks
Laurence

