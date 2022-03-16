Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA7B4DA909
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353497AbiCPDuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiCPDux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:50:53 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6714B85D;
        Tue, 15 Mar 2022 20:49:40 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r2so1018379iod.9;
        Tue, 15 Mar 2022 20:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=tllLYjeihl3WCpZ+6bZN55rZeTQGri6ijEtDDgRvbe4=;
        b=LxWJKfE5jaE1eUPu+QzevjWsHseVQJmmUqPt35Eu2/PvGk5JtyqsS2wTt7Jl0vDNuX
         xpkiYQH+0GMg+J5AcSoxZ1687AgKCZNDbH/cBwespePhcHI1ZEmQ6dgYFRhZTEt2Jrm/
         +ZQ/iOQjfnlS+sTpmaSG4R2tr+AnOggCcEc5BrGu9776QstcOcm3EMpoaseX1biVWgam
         6ecuZKAewwtehYRj6jwUg0uEPKYRgD/iMGIBH/i/Np9bAMuR9JcUV5+HoXPwRRzOKE2V
         GFX2IYhjWYNDIUhD6pALRp/yKYLE3uCS3kofYZP81CiBo4kokVlNSmDPWT+4wLlYrs4C
         VzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=tllLYjeihl3WCpZ+6bZN55rZeTQGri6ijEtDDgRvbe4=;
        b=cUpgEmgvHrSqDHwDSj+J/dYozCpLBM3Ot1PmAJf+CsAROgy+9bOEiXP/pKWIxheybE
         FKAaeLNIYlDOf7jgNnTOLVn1ahQmtXLRPIl0JpboiDvpsJE4hweIXrmHtY8svyUAO/9Z
         7KjmZ27SZKwVInEl/zjU12ahjhAuSPIoxHzefWW9gwH40dnFP6SADyWIpLPy9eyJ4/YN
         CFWlnXbKod1CusXOEK0miPEdJsLUu3BWMqaZufawPTK+PNzhoCnNo00nnoHj/RFlUlj9
         Q9WyFd15Kj+M/RkrsqZEaei+d8QbfNm2VZaguW7rwFBM1tYpnr2b67DaQ0mHyOyc3zpS
         QHBQ==
X-Gm-Message-State: AOAM532FzkPL5/i4ucmGPReGq3jpiiZoWFvYTvUbbqQ0jVf/VPIeYHUr
        A0tFGJX8yN92b34WdREjKTl+s5U51iErgA==
X-Google-Smtp-Source: ABdhPJziaLtJ5+FR+AXVhlTL1FqrjjadNaHkTfQIKdKkeXtdkIH9sP1RjmU1ux7c1KXxZPsRw1fv1Q==
X-Received: by 2002:a02:6383:0:b0:314:d9da:13b2 with SMTP id j125-20020a026383000000b00314d9da13b2mr24698552jac.99.1647402579786;
        Tue, 15 Mar 2022 20:49:39 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id u15-20020a056e021a4f00b002c665afb993sm595481ilv.11.2022.03.15.20.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 20:49:39 -0700 (PDT)
Date:   Tue, 15 Mar 2022 20:49:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Message-ID: <62315e4c32c26_94df20814@john.notmuch>
In-Reply-To: <8d228b106bc1903571afd1d77e797bffe9a5ea7c.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
 <8d228b106bc1903571afd1d77e797bffe9a5ea7c.1646989407.git.lorenzo@kernel.org>
Subject: RE: [PATCH v5 bpf-next 2/3] veth: rework veth_xdp_rcv_skb in order to
 accept non-linear skb
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce veth_convert_skb_to_xdp_buff routine in order to
> convert a non-linear skb into a xdp buffer. If the received skb
> is cloned or shared, veth_convert_skb_to_xdp_buff will copy it
> in a new skb composed by order-0 pages for the linear and the
> fragmented area. Moreover veth_convert_skb_to_xdp_buff guarantees
> we have enough headroom for xdp.
> This is a preliminary patch to allow attaching xdp programs with frags
> support on veth devices.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
