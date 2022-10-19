Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7126048E9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiJSOQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiJSOQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:16:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985E5148F5D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:58:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id fy4so40111891ejc.5
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NgrAU2ZC0t9fqE/fjEGXd4XyCharN5aoAq7bekBw2Ls=;
        b=GVWD757M50MSG8JpT9gEVDGgCo/tOhoWCWs/CLgYq1V7KTufnHvp7gJP+M7AyijUuq
         GWpE8nfu9XhUfCDDTlLo4ieqFTYBCvQW9qbrtqukCa07qVyAvI8/4yR+TXHuobWx50BC
         2ndlaEgRHiZNXp491PZAMH7TWN+eBBS+kVFwXWpLP5BnufZJ4vchf36Z6vK/jLZDnG5G
         T2hlirJYGvotPp4RlNhUQnqVDtNFumxOhugBu/XQaGYSehNJkWtkkiiNbT4whrveefaC
         Bpo+FDIMi4TT37V1sGDEjJfWLZmk93wBoeYHo0/92Kg9AuhZ5z/R6yuL1Kq5iZCjSjYA
         Zn0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NgrAU2ZC0t9fqE/fjEGXd4XyCharN5aoAq7bekBw2Ls=;
        b=nxcqQteXGrJoa1dZ/M/VU6GKgQ3SY26dhfZ1ScZ4efwUq7tHUcGasZCH5Zbme2opIe
         n6L8cVZmP3y1f7op1kBPcp/TFavOR3C0JkE7UJpywzJjG4NVu2tSdQteLlhUn5VZYRqy
         I95nRtPKUYW9qWU02uXyJ6gZzATLn8RPc6NEZoeUkrqf9MQ9BK6JnQYDhLPWw66VBcfW
         YgJwcuRhAKjOPBl5eBBS6I4jrRI61EBTwQIOz368TzSXsy/TL0iCCXOPuy6dZl66zTer
         yNQ93cMa4Ej0glddnIyjWA1DiXi5gLJRKg9d/yZeXZZlcPYoeIMtFbfPYnWoRXwnC6mM
         fhlg==
X-Gm-Message-State: ACrzQf2QDx3Gu6ma+emr1MuchnOUHFwCat/kklgt9Vdadu9V5cp7zBov
        kx2mI7Dzvz35/yTjXZdMwkAxx5iMmyOi4sYeH4g=
X-Google-Smtp-Source: AMsMyM5sZrl2y7/dsa7/acqIswV8PcLO7l8MJgSJfQ8niPdp9JG4pMsNbjTy+6Sz+HePYL9++5h/wCWtlIgkGeUEQso=
X-Received: by 2002:a17:907:a073:b0:78d:51c4:5b8c with SMTP id
 ia19-20020a170907a07300b0078d51c45b8cmr6749262ejc.355.1666187836989; Wed, 19
 Oct 2022 06:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221013155724.2911050-1-saproj@gmail.com> <20221017155536.hfetulaedgmvjoc5@skbuf>
In-Reply-To: <20221017155536.hfetulaedgmvjoc5@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Wed, 19 Oct 2022 16:57:05 +0300
Message-ID: <CABikg9ziSUJ5_DWro_TgCDMRYmgBfQNaEjKrCFQjaoUhkwRZOg@mail.gmail.com>
Subject: Re: [PATCH v3 net] net: ftmac100: support frames with DSA tag
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Andrew Lunn <andrew@lunn.ch>
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

On Mon, 17 Oct 2022 at 18:55, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Oct 13, 2022 at 06:57:24PM +0300, Sergei Antonov wrote:
> > Fixes the problem when frames coming from DSA were discarded.
> > DSA tag might make frame size >1518. Such frames are discarded
> > by the controller when FTMAC100_MACCR_RX_FTL is not set in the
> > MAC Control Register, see datasheet [1].
> >
> > Set FTMAC100_MACCR_RX_FTL in the MAC Control Register.
> > For received packets marked with FTMAC100_RXDES0_FTL check if packet
> > length (with FCS excluded) is within expected limits, that is not
> > greater than netdev->mtu + 14 (Ethernet headers). Otherwise trigger
> > an error. In the presence of DSA netdev->mtu is 1504 to accommodate
> > for VLAN tag.
>
> Which VLAN tag do you mean? Earlier you mentioned a tail tag as can be
> seen and parsed by net/dsa/tag_trailer.c. Don't conflate the two, one
> has nothing to do with the other.

I used print_hex_dump_bytes() in the ftmac100 driver to see what is
inside the received packet. Here is how the 1518 byte long packet
looks:
6 bytes - dst MAC
6 bytes - src MAC
4 bytes - 08 00 45 10
2 bytes - 0x5dc - data length (1500)
1500 bytes - data

I am not sure what is the proper name for these 08 00 45 10 bytes.
Tell me the correct name to use in the next version of the patch :).
Thanks for your feedback. I will make an improved version of the patch
targeted for net-next.
