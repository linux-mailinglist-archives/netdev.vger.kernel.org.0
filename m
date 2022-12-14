Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28DE64CEC6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 18:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiLNRRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 12:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbiLNRQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 12:16:51 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE4326F5;
        Wed, 14 Dec 2022 09:16:46 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so7890150pjp.1;
        Wed, 14 Dec 2022 09:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/1zG2tuJHv8bGjiNOZxxKGVCb/5dQUpWtcN2nAv7ybI=;
        b=qVCfEroakM1a0+SJMCc0vLfW5rRuyGFzDfa67AYYRFrs9DJbQ4mQyDSCW0NfuttDWt
         iL8A5Ex05zK7XT1aGrAWbdkhDCEkJlE+b6L9rkQOFeZbTWjdNgdRUlDatMvW0BOxv2tA
         bGyjb4VUBUokGf01pCF3YEz8dZKNH9T9A7griEps/5l4F16uw3KTDZAjiMzHyFaH9jNt
         bT0326ZDfUyhz3YXy2DyvmpBpaPeaFbCQKu1CZvZJh8KtsDqD1D8dBGY6lC/fpj64nJJ
         HNbK+7ll/ZZjeQyKGoffKkvVCueJ8odsCKpwoYbQSqwob6vFLE5czjDhDhVLaK3SBHzD
         5Hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1zG2tuJHv8bGjiNOZxxKGVCb/5dQUpWtcN2nAv7ybI=;
        b=w0oXkjF8AkQdJjQJz5gwP30CQRNoRy5GEM0+tvQxpDnCxUqcosBi6AfxqnlopBPf+D
         +p9IYMD7Wa/HZ90kwRbalj08+bK54ctVS+rANWkp99XDGEdMun5/yMJY1XYmI5EMFHS5
         aLwgjxDU/DkaTe33cEkAQb2gXhPDJTjCgh+azgq6QW51e83xo3qQSRi/HljTk9wPbvjE
         cilN+8YJ/bsbtSyQqEG+GlrWxU9yZB73MlMaS3K92v+pnqnIrG7bZ9NOrjUyPT1TBI6L
         DDuqfvgABmvcOS9uMp8VL/Hik2t8DqxCqLAjFZ+60UU3WHg78J1xVVG8URjyA0KzRh+L
         XTuA==
X-Gm-Message-State: ANoB5pnezhfGOmiTY2e3vHxkq3LA5wIZ/7rqCxO4VAASTT3ZQLbURS2J
        IL/oe6lokG2mrO6oinalrgEHn7Xl/HtWhS0IW078FUo1
X-Google-Smtp-Source: AA0mqf5S0+Von62w2CT1G5A0z9m2g63T5ixgtI9ZYiK2BnSStZ3EOCQkSdUSyB4FNpbAAm3hO2ljaV61ogv1RIu9aDg=
X-Received: by 2002:a17:902:9a8b:b0:190:c917:ab61 with SMTP id
 w11-20020a1709029a8b00b00190c917ab61mr479029plp.93.1671038206116; Wed, 14 Dec
 2022 09:16:46 -0800 (PST)
MIME-Version: 1.0
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
 <cf6f03d04c8f2ad2627a924f7ee66645d661d746.camel@gmail.com> <CY4PR1101MB2360D262A260CCE7ED0FD87390E09@CY4PR1101MB2360.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR1101MB2360D262A260CCE7ED0FD87390E09@CY4PR1101MB2360.namprd11.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 14 Dec 2022 09:16:34 -0800
Message-ID: <CAKgT0Uc2cmK8+BZoBO_3of86MN0AvBQc2je-Jyoocjw2DVn+7A@mail.gmail.com>
Subject: Re: [PATCH intel-next 0/5] i40e: support XDP multi-buffer
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
Cc:     "tirtha@gmail.com" <tirtha@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 7:56 AM Sarkar, Tirthendu
<tirthendu.sarkar@intel.com> wrote:
>
> > From: Alexander H Duyck <alexander.duyck@gmail.com>
> > Sent: Tuesday, December 13, 2022 9:28 PM
> >
> > This approach seems kind of convoluted to me. Basically you are trying
> > to clean the ring without cleaning the ring in the cases where you
> > encounter a non EOP descriptor.
> >
> > Why not just replace the skb pointer with an xdp_buff in the ring? Then
> > you just build an xdp_buff w/ frags and then convert it after after
> > i40e_is_non_eop? You should then still be able to use all the same page
> > counting tricks and the pages would just be dropped into the shared
> > info of an xdp_buff instead of an skb and function the same assuming
> > you have all the logic in place to clean them up correctly.
>
> We have another approach similar to what you have suggested which sort
> of is a bit cleaner but not free of a burden of getting the rx_buffer struct
> back again for all of the packet frags post i40e_run_xdp() for recycling.
> We will examine if that turns out to be better.

Sounds good. Keep in mind that there are multiple use cases for the
NIC so you don't want to optimize for the less likely to be used ones
such as XDP_DROP/XDP_ABORT over standard use cases such as simply
passing packets up to the network stack.
