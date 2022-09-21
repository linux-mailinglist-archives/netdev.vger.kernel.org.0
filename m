Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF885BFF19
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIUNoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiIUNn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:43:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B082D7C319
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:43:56 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j12so5933683pfi.11
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=l9Mz90rwCkdg+yvYtpKCOuXDOQ7hNvOvFYOKjGiT34Q=;
        b=DFGf9vcEpmEAVcakpQLoKlWsLgoIdB4v3jKlgCGqO/U2urMjby+TtwzM2MANRwX2WL
         bY+JiVJLllkUsFnVmc/v7y0jyFz2Xk0qUGBYcLdx6i8cHXbk9ZufUF/uv23cwaon7equ
         NOe5v4nPyhEKancycK0a9YXen9sfM/J/OZy3pgCp3Q4OXZFiYVT2h6R5fNSXzCYBlsZB
         AeZXnquhUaIUNDJhNoXFl6xrMXQY/VbHsLh08S6LDE85K81o5uhbONg909jjgAemNp8F
         +cL2qAGtWGvQdM1720aIGFxZRPEeMalwSPHy3TbAtY/QEG1b0T1yIccDsX9w/E8d8UzQ
         zV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=l9Mz90rwCkdg+yvYtpKCOuXDOQ7hNvOvFYOKjGiT34Q=;
        b=j0Q3n8aCFTdkL2XlJRkEcAXRGy8d1p7gYCLQZuULYyW4padGR1EW6qmMSRz142MHFx
         1wcyc6ve4cXxD8nHbQmBngjbdXPfOblNi6PixNYmHkXbj1nGprAxIFu2PqhetYMQQyZt
         2xtemmBIGUwj5cX7apAC5F+ypft/H+6c6TDRjaxcRidZkxWAI2CalH9kw/3M2j6wsZFw
         2U+W4JlI3HsxPXjXzEOHK5DNrjkMTY3+ZBBrr/domhgJb+Tx9kg8/wSwIoipJmxNsn+x
         8kUOoVzewkq9ad42avP5XqrJm4FLqI8TCUgVTxnmrrcFTw9sbmNa2fkSs+ZCFhffuJwA
         dA1g==
X-Gm-Message-State: ACrzQf0NdPpLVHk3kePvxtR3u8Lg+A7mWvYTMedyfwhfgH4YJpQQ1sTH
        bCwC2jE4doQ/AYA8y1VlS483jyBXBZNEgJzX1vbxedh+
X-Google-Smtp-Source: AMsMyM6keIrlFktfqRmePwYZzVPwhog+2XNooLcaoPTKDhVJiWndbbLvk9DDbpwUPI3PCnb4T5rtarcKD50WitGT5zQ=
X-Received: by 2002:a63:2a02:0:b0:42b:3b16:5759 with SMTP id
 q2-20020a632a02000000b0042b3b165759mr24383511pgq.564.1663767836121; Wed, 21
 Sep 2022 06:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220906052129.104507-1-saeed@kernel.org> <20220906052129.104507-8-saeed@kernel.org>
 <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com>
 <20220914203849.fn45bvuem2l3ppqq@sx1> <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com>
 <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com>
 <166322893264.61080.12133865599607623050@kwain> <CALHRZurLscR15y48fzJXC4pAWe+wen8JZVCwk2fwT4wujqSdRQ@mail.gmail.com>
 <DM4PR12MB53579A35887680D5211AC282C94D9@DM4PR12MB5357.namprd12.prod.outlook.com>
 <166366166577.3327.17682877096646901460@kwain>
In-Reply-To: <166366166577.3327.17682877096646901460@kwain>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 21 Sep 2022 19:13:43 +0530
Message-ID: <CALHRZurXmiYtK-vW6efG=QwdF7h1BhJn8E5e60rg1KfFfmhnDw@mail.gmail.com>
Subject: Re: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Raed Salem <raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "naveenm@marvell.com" <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
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

On Tue, Sep 20, 2022 at 1:44 PM Antoine Tenart <atenart@kernel.org> wrote:
>
> Quoting Raed Salem (2022-09-19 15:26:26)
> > >From: sundeep subbaraya <sundeep.lkml@gmail.com>
> > >As of now we will send the new driver to do all the init in the
> > >prepare phase and commit phase will return 0 always.
> > >
> > I think it is better to do all the init in commit phase and not in the
> > prepare to align with most drivers that already implemented macsec
> > offload (both aquantia and mlx5 and most of mscc implementation), this
> > will make it easier to deprecate the prepare stage in future refactor
> > of the macsec driver in stack.
>
> Yes, please do this.

Sure Raed and Antoine.

Thanks,
Sundeep

>
> Thanks,
> Antoine
