Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3519E6EF571
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbjDZNXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 09:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbjDZNXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 09:23:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B64525E
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:23:07 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-94eff00bcdaso1307520766b.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 06:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682515386; x=1685107386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=94RFcobVU2BOSXI+w3jlybnQelL4xN9yEFnF/tEpk9A=;
        b=FRjDTroVDwdesWheLsuhy1ypAm1WkDWFN83U/+0uLnb4ERSBf8vbR4gtoh8bUk/F8L
         RAC4Q4bUAwMRJXRRwSFixircev+aOrNhQfQwMFLtJjiCRBmFgzT+RfoBU8BSVCRkGr+Q
         hsL3wOJbKNDCRPWHacoG0M9ycn7VAWEPkfGDEpaqgtzmbdd7JBYBY6WuUJD3PC4cg769
         6qPfFszA131wi2Urb4v7OwSI957V/UeI19SaGRc7rIgTCe6C6aomGyHEkxzI0MYEVdfA
         weNvTgkdobmfWWQNYe2lOvZlcpA735arCFPUWNnud6KYQXSrzCmg8j/zKwfocc39sfk4
         A4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682515386; x=1685107386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94RFcobVU2BOSXI+w3jlybnQelL4xN9yEFnF/tEpk9A=;
        b=R+26RY9LLRRmsNjw3x6+MbPRO77rGDsfd9SF1/0PxvQrR72KjWcPS/ykiScVdyKkFa
         Oj5FiMDe+cAteGYzyHnoel9jHIzvkqxNsm8oODxcDMN/bRogMFZXejQjmFoJaACE6MQf
         slA+auVqgjAK9yvUk1b8HCoVTmdT1juhnxm9UCknzpC6MN1oGiKVbGM+EdKVoGgz+IlQ
         cQyY60Nct6E2zWIyr4xYQlJ1Ga95ZI5oZFhZ7acOrH308tpM1cO/VUhNFxCRoHkgb6RE
         UcB6tMwTs+lKxlMyxm1kvPkQYpdMZez9Rq6ykBb94PPhe/5KdUxzuv9J7Pgepx9TfUFD
         Pb4Q==
X-Gm-Message-State: AAQBX9cBprbIquoJfHZ/57sO0aWqYWMtZuVwHm177WpaaDfNNe9NKPJZ
        w/ilGnQxkqL5fjn25B7jQ+w=
X-Google-Smtp-Source: AKy350a5/E5I6mAZ3pM7Xu0E0lPf0Yj0mliHV1SrucNCKpeAysNoq9aMfGezGucjfQ3nDwxcg6wZdA==
X-Received: by 2002:a17:906:4a99:b0:959:af74:4cf7 with SMTP id x25-20020a1709064a9900b00959af744cf7mr9703292eju.70.1682515385986;
        Wed, 26 Apr 2023 06:23:05 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id i17-20020a056402055100b0050685927971sm6778588edx.30.2023.04.26.06.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 06:23:05 -0700 (PDT)
Date:   Wed, 26 Apr 2023 16:23:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: dsa: mv88e6xxx: mv88e6321 rsvd2cpu
Message-ID: <20230426132303.frxluy56dxi7ofbv@skbuf>
References: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c798e9d-9a48-0671-b602-613cde9585cc@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Angelo,

On Wed, Apr 26, 2023 at 10:12:28AM +0200, Angelo Dureghello wrote:
> Hi all,
> 
> working on some rstp stuff at userspace level, (kernel stp
> disabled), i have seen bpdu packets was forwarded over bridge
> ports generating chaos and loops. As far as i know, 802.1d asks
> bpdus are not forwarded.
> 
> Finally found a solution, adding mv88e6185_g2_mgmt_rsvd2cpu()
> for mv88e6321.
> Is it a proper solution ? Is there any specific reason why
> rsvd2cpu was not implemented for my 6321 ?
> I can send the patch i am using actually. in case.

I don't know why mv88e6321_ops doesn't define a mgmt_rsvd2cpu()
implementation. I would agree that it is necessary, if available.
