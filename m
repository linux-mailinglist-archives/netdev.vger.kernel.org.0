Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1A36EF480
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 14:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbjDZMli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 08:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbjDZMlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 08:41:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B0C6585;
        Wed, 26 Apr 2023 05:40:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b50a02bffso5810689b3a.2;
        Wed, 26 Apr 2023 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682512843; x=1685104843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sosN6q7mjWABQa1iFcHLQ7HcWfsjeMtm3Mt392Dc1Ok=;
        b=LHEhXfBwsoX5wQPtnAnd/oSeQOBl5rvEvn7Jq2inf11DTsMzwiilhui/ckik+6rGNf
         qeVSAL7SRVHE2nj23tcVdeylQ9ODv7KttwZEha1dl04Uz2VuK3FanEMlfBA1WRgs8POM
         G5Ae8uveZTMTYzFkzAjfO1rOf0DgWsHV2pin2KVCMJlqlF0CcP/ObpMkkG2KwrmYvR+a
         DjmeyUb0tbVgM1POPQ0QoY/JJ/MDIiTWVHa4UgyNxL2IJW8DVXfSmB5msXnAe6NgA4Vu
         9O2zG9VNIeDLh8bo3BQSxEQsCc1d9giheLcKV3mnd6NGuLTmQZvN7zs67YTC7hIIblOE
         w+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682512843; x=1685104843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sosN6q7mjWABQa1iFcHLQ7HcWfsjeMtm3Mt392Dc1Ok=;
        b=laY1g3/GrjsQ6Cof10eQNHdDnE27AbqVACq7n8aOglPYPRggiFrWG75i0Xw8RJM65n
         3oaHTNch7AwsUVfyFbceA0NnHrTJssnZVKHhYuIF8URNBO3CyPoSHoRnRNtaolzdS525
         +4u3iOvD2NWNcCVtC6UjSRr5oqp0JbslcsyJ0O6WMNTjKu6bONUmIGvCrYDqpoKIUT6n
         eOgGsa2j2AUDnPU0BYP5wsTDuLD2EaVIephtpHKOQiaej8ikbYDZWMtR43Ak9E2Yctkd
         ZA6d1X5ZObKyhZxfGeg2P9tv5A3Nu4qc059Nkdx5Ur76h4BAgTqJ8ge7Q1/kX+RXML76
         2LyA==
X-Gm-Message-State: AAQBX9djMclM9mLzcH5oYmposuvuA1TNtX0NoOynuUkLJPokiGRcWutp
        qtKacXBKnxjjPKa8oNSOEzZgwTzUbRIpLxYwsLRzF15QqsRNww==
X-Google-Smtp-Source: AKy350ayHesJaV9Si6f/E/Wp+h9A2uT5MsJ/lHDtqljcQwtP1Ri7lwAypa0hf/VN91OAfADvz6myhrHxslCOx7xdqxE=
X-Received: by 2002:a05:6a20:12ca:b0:f3:1b6:f468 with SMTP id
 v10-20020a056a2012ca00b000f301b6f468mr19381338pzg.6.1682512843128; Wed, 26
 Apr 2023 05:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221105194943.826847-1-robimarko@gmail.com> <20221105194943.826847-2-robimarko@gmail.com>
 <20221107174727.GA7535@thinkpad> <87cz9xcqbd.fsf@kernel.org>
 <877czn8c2n.fsf@kernel.org> <CA+HBbNFCFtJwzN=6SCsWnDmAjPkmxE4guH1RrLc+-HByLcVVXA@mail.gmail.com>
 <87k02jzgkz.fsf@kernel.org> <CA+HBbNHi0zTeV0DRmwLjZu+XzUQEZQNnSpBMeQeUPiBu3v-2BQ@mail.gmail.com>
 <87358hyp3x.fsf@kernel.org> <CA+HBbNGdOrOiCxhSouZ6uRPRnZmsBSAL+wWpLkczMK9cO8Mczg@mail.gmail.com>
 <877cxsdrax.fsf@kernel.org> <CA+HBbNGbg88_3FDu+EZhqMj0UKb8Ja_vyYsxGtmJ_HGt4fNVBQ@mail.gmail.com>
 <87y1q8ccc4.fsf@kernel.org> <CA+HBbNH2fzr_knOE9EWD4bUi-guvRa07FAxc9WyCH0jK10BLvw@mail.gmail.com>
 <87fsafpg63.fsf@kernel.org>
In-Reply-To: <87fsafpg63.fsf@kernel.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Wed, 26 Apr 2023 14:40:32 +0200
Message-ID: <CAOX2RU5EaRrcKW7uhmDQbUO-TzOOnKAsx5HKtRjMDTMBEZj4tA@mail.gmail.com>
Subject: Re: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Manivannan Sadhasivam <mani@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ansuelsmth@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Still not sure what you mean. Are you saying that this patch under
> discussion ("wifi: ath11k: use unique QRTR instance ID") also works with
> QCA6390 and it's possible to connect two QCA6390 devices on the same
> host?
>
> Or are you referring to some other hack? Or have I totally
> misunderstood? :)

We probably have a misunderstanding, QCA6390 does not work with
("wifi: ath11k: use unique QRTR instance ID"), that is why we in OpenWrt
limited it to QCN9074 only so far.

>
> > so that is why its quite important for OpenWrt to have a generic
> > solution that works on all cards.
>
> I fully agree on importance of having a generic solution. It's just sad
> that it seems people who designed this didn't consider about having
> multiple devices on the same host. It looks like there's no easy way to
> implement a generic solution, we have only bad choices to choose from.
> Your solution[1] is racy and writing to a register which is marked as
> read-only in the spec.

I agree, this is purely a hack based on what QCA is doing downstream where
they hardcode the QRTR ID in DTS and write to the same register.

>
> Qualcomm's solution[2] needs changes in firmware and it's uncertain if
> I'm able to convince all firmware teams to implement the support.
> (Currently only QCN9074 firmware supports this.)
>
> Thoughts?

I mean, we need some kind of a solution cause trying to pitch using a QCA
AX SoC-s and PCI cards but then saying that they cannot use AHB+PCI
or multiple PCI cards at the same time are not viable.

Regards,
Robert
>
> [1] https://patchwork.kernel.org/project/linux-wireless/patch/20221105194943.826847-2-robimarko@gmail.com/
>
> [2] https://patchwork.kernel.org/project/linux-wireless/patch/20230111170033.32454-1-kvalo@kernel.org/
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
