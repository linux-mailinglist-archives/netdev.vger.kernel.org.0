Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9754E6B67
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 01:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356241AbiCYAGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 20:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348213AbiCYAGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 20:06:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA8A5EA8
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:04:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so1998460pjb.3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OWoekZX+K+s9wuQNjHOZiM3DFWBNSeQKggVjiSuM/vM=;
        b=L30pGwriqx9Li71zw9WTk5WirnAm6+/JMd8IDuh3A4guM+mdVz9T49GNfCxs2UHj8n
         aqEqbYctsf6BGqDc2CHtbHKbuHPlOpA/HF2/BlUwVH+xfPhZHocSp3S1UtdPjvqNQyKo
         ZbwP2Ci09RbVej/oO94YXW7vE0gDB6yljlBUBWJmO7o+ehSIgp6Dy1pTaYZg/Z9+ODff
         EWZGMSUonAm15SF56YUK9Bl9dzsSwTK6YK3nVbAlTF5kwhBVPJXkNsFq25c9u7WmEEv7
         Ps+j6udvNrIEWyg5vWUBsbwjkuLkB7s2zbmcDtLqgeABpGXXtgNX1exOUH902UtpquJG
         jM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OWoekZX+K+s9wuQNjHOZiM3DFWBNSeQKggVjiSuM/vM=;
        b=kfJk1jNukdZ10hd70QInJE3kfP/bFMF0ts2Ze7Sda5kzdk0UJ0AEuTUYSEV+DE2ckm
         BeLR2WMnpf/4lFw2IOZDBcF745e41GlyzdhTogCL8TN5cjXCIs9sMPFEcn05cWmHuDeU
         zOYJY2d34z/K/vDOFV5xIK/Pi8W9kPrqfpknM959TE615udxv/hl2Ur6Xdr19zWmpaif
         8rhWnemPaMsQQUeV6NA7OIz9RC9YN1rKfkppasRLyg6Jg7DR/Zrf8BLx6m6f1lHDEt2C
         NLSoTXZ12uuVGMhyL1XLg39bE9sfHUiWqHDB1odyjf7lVxKAMKPnHi0iVo+NXMMQlK5Y
         uecA==
X-Gm-Message-State: AOAM532dsR/WOCxlkFA9bPl2qSYPcY+qjmfL0G6wkmWl01ea13x49vGY
        PTamJABGbNhEJsjNcQYCCU4=
X-Google-Smtp-Source: ABdhPJxmJjU59SoXK3/O9C+SzcDmS6qOMwH6WIZ4KCiXJpiPhAbAFB9zdmPko+ydzcHgRICKaPN+8Q==
X-Received: by 2002:a17:90b:1a87:b0:1c7:3d66:8cb with SMTP id ng7-20020a17090b1a8700b001c73d6608cbmr21595857pjb.142.1648166675580;
        Thu, 24 Mar 2022 17:04:35 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm4510426pfj.146.2022.03.24.17.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 17:04:35 -0700 (PDT)
Date:   Thu, 24 Mar 2022 17:04:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
Message-ID: <20220325000432.GA18007@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-6-gerhard@engleder-embedded.com>
 <20220324140117.GE27824@hoboy.vegasvil.org>
 <CANr-f5zW9J+1Z+Oe270xRpye4qtD2r97QAdoCrykOrk1SOuVag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5zW9J+1Z+Oe270xRpye4qtD2r97QAdoCrykOrk1SOuVag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 08:52:18PM +0100, Gerhard Engleder wrote:

> I thought that PTP packages are rare and that bloating the socket is
> not welcome.

Some PTP profiles use insanely high frame rates.  like G.8275.1 with
Sync and Delay Req at 16/sec each.  times the number of clients.

Bloating the skbuff is bad, but the `sock` is not so critical in its
storage costs.

Thanks,
Richard


