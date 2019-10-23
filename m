Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB02E0F3C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbfJWAdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:33:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727610AbfJWAdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571790829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L06TXI6Vj4mhhNtCHcisydZYDybVAGuxU9Mq4ab/6+0=;
        b=cqqGv+QHdw/lChII00LDxjOYfdLa05khIZN2gabvLvYUC4f/i0l2YTYXtnkSCPBj+Ra0QY
        z3kavi3q88pPqrw4nF14GpOKjo5+M6H/UiMX7Nkd06dKqu8xS44ePKZ4W0Z8m9eInYlbxp
        RJ7ULLYTIfY5weSGJuiuYjxrBeMibAQ=
Received: from mail-yw1-f72.google.com (mail-yw1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-fo8mxo3NPmmPc1rTJ65tHw-1; Tue, 22 Oct 2019 20:33:45 -0400
Received: by mail-yw1-f72.google.com with SMTP id s38so485086ywa.5
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=L06TXI6Vj4mhhNtCHcisydZYDybVAGuxU9Mq4ab/6+0=;
        b=dDAi3U1EOY7f+qL9SPxmamHJ7bhJTVtzYvtlLeSnIwtR61GLpU5D8uyFlbv+3crZl9
         RdkoJ3o8/3l6ueS3hkTh4XAXVCLt2LMP2GWNFJQESm0PlBrM54G2djn/CD/Xp+ENJ7cx
         TS205GICBgDMAXp9gr/90BRhLuYPzBgRbrqsUcgAkrcoylwqZFjO29wf0JWJnvj8hh/k
         dtPmDC480vTddnYpibt01ZWJRmWlxGrG9CPgyFeC4iCpDm+X0gS37t1b4QCAQTHIoqpT
         fT9pdrnhnkEWtLJIwcehYSIpktNT5gKhL8gbC+MpVHWDvev3rDjIiywZeKKMzYfEZMjx
         8rMQ==
X-Gm-Message-State: APjAAAV06qiXRcTf9SarGJKDhrtDR8wckLhDEYmsdCHtK2lLimF6LaIn
        R7bJeYYVo4dKGfa1kxWfLoLBDrWpPFgd9y04NMw4xiGU5xKBNcbgJIAZvjA/KtvuXOrmRDkVHgk
        iSf1P4SdTsQ7bp1Sh0iSihAbGYdF3jMUT
X-Received: by 2002:a25:70c3:: with SMTP id l186mr2713971ybc.233.1571790824982;
        Tue, 22 Oct 2019 17:33:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyHFatb7VN3aWeF2BTP2HzwmupBAgir8JASamIqoNVXs987KedyWPbTEyTBLNfMHnYICr1i78zqyEeaC3G4skU=
X-Received: by 2002:a25:70c3:: with SMTP id l186mr2713964ybc.233.1571790824789;
 Tue, 22 Oct 2019 17:33:44 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Rix <trix@redhat.com>
Date:   Tue, 22 Oct 2019 17:33:34 -0700
Message-ID: <CACVy4SX9qbe3D7ZVU9dredVcTrP9jd2LB0AaFUSmiPeqeaj8kg@mail.gmail.com>
Subject: [PATCH v2 0/1] xfrm : lock input tasklet skb queue
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Vehlow <lkml@jv-coder.de>
X-MC-Unique: fo8mxo3NPmmPc1rTJ65tHw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rev 2 is Jorg's original patch with some if-defs to lock only for RT.

I have tested Jorg's change, it works on RT and since it was first it
should take precedence.
I can appreciate not forcing the normal kernel to move ad-hoc to RT.
So I hope that the compromise of conditionally including the change
will be acceptable.

Tom

