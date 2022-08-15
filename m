Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7008A595229
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiHPFne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiHPFnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:43:07 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B2612C342
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:32:27 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so12469863lfr.2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/3IXWzd+wl2RRDXeLv2+xA05vlC4U88YqM5/n+NeSEQ=;
        b=K3GMgspDwTktDa13IofgOH0wIJzbay3VW81an1jha0AKmOvhDPlvRk0WOZp6aDvlbD
         6//WGvjCK/LH0DzeGdavGl9SU1jN+Muei6YeSDdFyN+n9WLwulVhMtFPW9uH7+1wRBge
         tPfBSs5ZiDfdB4kY4wPKlDhGDIY+DTVDjQvf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/3IXWzd+wl2RRDXeLv2+xA05vlC4U88YqM5/n+NeSEQ=;
        b=TnzVJC6AjL6Tt8zaWPnm4IwWK1PBrxk2tJQN7K9lYw68Wdidh9A/8aIdWA5cjGnGGT
         SdDPXy4Td7yCov9AeV+8vtkrzDFSQkBKkdhIrNuXkbP1aOmz2NX/wuVzbUYv3Njh567G
         oU38E+5C1/3913J/IKamVsU9xirKVGYXSeuZK62UUYs7TR7S1/8ld8YtKq7pHnvkquIP
         wkLttlj9h59PFYD595f6NnIhipRPZ0A1Ga4B/qfM+DaqlcbvsjQ5kOsjetqYcbHk3p8D
         PuazGBGpp6qGLgrGXlbF/a+NbUqdF5CuCwdrtpx4aoocS0J/+kvC8y+sFURt2zHjYwra
         2QCA==
X-Gm-Message-State: ACgBeo0gpjrG9tO7KoWQ7GRJyH/0vXP/M2l6UHL+6kj6TEIzSwDfhW5R
        /f7ulNSI7vcD9di2a0DsmSFhSWnzhk7i1kA1kn8=
X-Google-Smtp-Source: AA6agR4DDEUXPiIbSjJt8H+qiFXiX1AXM5SGPrSRdSDugjAOT/bDgB3keF69soMh1UK2rai+FZy7rA==
X-Received: by 2002:a05:6512:25a3:b0:48a:e7e7:eea3 with SMTP id bf35-20020a05651225a300b0048ae7e7eea3mr5761643lfb.205.1660602745732;
        Mon, 15 Aug 2022 15:32:25 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id b8-20020ac25e88000000b0048a88bf3efcsm1211350lfq.53.2022.08.15.15.32.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 15:32:25 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id by6so8943557ljb.11
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 15:32:25 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr9331179wri.442.1660602284992; Mon, 15
 Aug 2022 15:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220815215938.154999-1-mst@redhat.com>
In-Reply-To: <20220815215938.154999-1-mst@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 15 Aug 2022 15:24:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj=Ju_jhbww7WmpgmHHebMSdd1U5WBjh925yLB_F1j9Ng@mail.gmail.com>
Message-ID: <CAHk-=wj=Ju_jhbww7WmpgmHHebMSdd1U5WBjh925yLB_F1j9Ng@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] virtio: drop sizing vqs during init
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 3:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> But the benefit is unclear in any case, so let's revert for now.

Should I take this patch series directly, or will you be sending a
pull request (preferred)?

             Linus
