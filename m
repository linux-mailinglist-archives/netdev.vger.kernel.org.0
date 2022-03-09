Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E814D3928
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiCIStT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbiCIStR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:49:17 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717671052BF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:48:18 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e6so2730272pgn.2
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 10:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SvWoE1x6Gk6hUjzG+NoOkTv5USu0UdA/e17GnBMmEbQ=;
        b=U7rIukUSf6oqfn0CS4uw4DI1r172VpEfdRuybfR2DtojfSC7z5xjOgpArqoU999zX/
         h+rutWS7UP4t3eqQjHtW58vq4IPCGCv7Qy4eI8IwrtGUGeCCL1CknoTIjSNxtBERwaGh
         aKFi5qT25uQZdNAFNoxXJOZdR//XLPGAbBv/BewK/HL7Yz3nACXOEr337mkCzVVzzwjc
         eGwHyTha78qIWhC2DRvCclCNuTla2LE2md/eDmZkWoDbMlbMqYSx+K7P4sT0w3lKqBHy
         TrnboBCJg1o9SQL2O7igNHQNzryDEYbHcL20uSR7PCWqcOokQUpNM26DdpIwV0esDEi5
         uHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SvWoE1x6Gk6hUjzG+NoOkTv5USu0UdA/e17GnBMmEbQ=;
        b=puTqg6RsRUmK/hhaAhYHwpueIIjDPcd5H/kg0XoReizm+u3mrcqPCv8ZX2WY1+V5q9
         68U9TvQgAT0sBifEk2URrgDube63HevSh7a6B8xFzx90EaireKGYXph9AbuyV8SXfJrd
         N6WyB39tSASFh3dhwL3rpWjTqVsObJN1w/CuMY6XOOqnbIA1SpvAHWmITkEkSjDhh9HE
         00kScL2Ft09/o6AvE4/Kqkd+NFm2WWWtZ64Svwd5fIUqqPvjgp46bx1QM9ljWQ8jQXh1
         Z9H3Q5nFq6eNTZeh0xTGJniK48sjq2eTmDCbD0EQna9fPJ7csPynnYRrrbHhZ9vPZjXR
         NzZg==
X-Gm-Message-State: AOAM531+5iOzGMHZ4RFXuL+0F5zNc3rtUnKSnX8VIHl/KFZ6jW2jIYra
        jYE3wFzVVaNeKbYoWgADTmVOLw==
X-Google-Smtp-Source: ABdhPJyI+BIguRaA13B8I1lVmnRRYb2s8b4fqF1+IkxFjr0MuDQ6z1eLnco2xR5qeoZVfuN1xCKNOQ==
X-Received: by 2002:a63:2d5:0:b0:380:b650:f948 with SMTP id 204-20020a6302d5000000b00380b650f948mr899727pgc.37.1646851698001;
        Wed, 09 Mar 2022 10:48:18 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id kb10-20020a17090ae7ca00b001bfad03c750sm3378204pjb.26.2022.03.09.10.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:48:17 -0800 (PST)
Date:   Wed, 9 Mar 2022 10:48:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <parav@nvidia.com>
Subject: Re: [PATCH v5 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Message-ID: <20220309104812.7fb9b198@hermes.local>
In-Reply-To: <20220309164609.7233-4-elic@nvidia.com>
References: <20220309164609.7233-1-elic@nvidia.com>
        <20220309164609.7233-4-elic@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 18:46:08 +0200
Eli Cohen <elic@nvidia.com> wrote:

> +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> +		uint32_t num_vqs;
> +
> +		if (!vdpa->json_output)
> +			printf("\n");

Should be using print_nl() which handles oneline mode
