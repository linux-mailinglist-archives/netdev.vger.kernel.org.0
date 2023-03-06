Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C80E6AC8B9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjCFQu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCFQu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:50:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276FF30EA7;
        Mon,  6 Mar 2023 08:50:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so9356327pjz.1;
        Mon, 06 Mar 2023 08:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678121366;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FyzVPjWfXnTi2A6JA+vLWl/vlGfJCkJsgnI57YCj2dk=;
        b=aTRhtOKzopegMmO2yssOZkimSjssIB1Fe4aC8HZEsD3OR5cnh4N2g7iuSqfDbS9K5N
         CS8TVBVdeQZqQfD3dFmdVX3QUkxzNkaZ5MaF35ZM6wNjohaLBeFCivpxT+cs4mnddsN1
         4TMJT+ngEmiRar/0a7wziePefj2s334WYFD1cml4bH29b/21M17Q0ZMzTPan6WcmWTyV
         9z+EsmcrSJrphT/ZIbuuL729qCpqvNQLIwNflHSDPWKS/qjn5RYl046inEUlPM8721Bx
         ifkSjYxCj6fWSgL9rgRzzT4NIF7Zp898TfP7yV3sl2SLv2TiV5V89riysdMyUhr4XQ+t
         SKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678121366;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FyzVPjWfXnTi2A6JA+vLWl/vlGfJCkJsgnI57YCj2dk=;
        b=adHS1iv1J1c7vEGz9R+yKpO3Lp+gJw7TDDxwUU6UKG38J9aTZma5CUneUTU7z91DPg
         1ffFvsmN+qvgGUlkRdXF5kVZPbT5TWbOsFikeLaDlMdE8/XcUXFDp9yb10NYgfYP1v1J
         7W0w5vmjP3HhpMGQUY1fvFhMGFMeFctKEQCsVTX389KrnEJE9OI2bQLSpF7gkqKjGnn0
         4DlhlHPpzxYpuWetoXlYV9YgRE2otvr0Ml8L9F1ZmpeP4iWtvkN0JsEwqOh/bV481ll7
         ZmPHoUrCmeQIspvVoqDfs6Yne4D3FJg3rRhj0kdKzIWejJGfoITfJUN5AsuUdutP3r1d
         ufsQ==
X-Gm-Message-State: AO0yUKU581daoxSAUHX/XDIw0c1D9OrJMW7HWAj3YVxujaBgI95JvrK4
        5SP1GIqasulWgJJUUQKQjiPStpAgiX0=
X-Google-Smtp-Source: AK7set/tAvMHEOLBgk/J+TSbInWJpoBAIk9fk2swfjHlWNVo4lmtt2y54TjkH+Sact5n0jkX8+6sNA==
X-Received: by 2002:a17:902:d4cd:b0:19e:23c1:4c3d with SMTP id o13-20020a170902d4cd00b0019e23c14c3dmr14086927plg.2.1678121366695;
        Mon, 06 Mar 2023 08:49:26 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id jy11-20020a17090342cb00b0019cbd37a335sm6962692plb.93.2023.03.06.08.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:49:26 -0800 (PST)
Message-ID: <3507f6a501688243d1f16ef65753acc40b9e85aa.camel@gmail.com>
Subject: Re: [PATCH net 0/2] add checking sq is full inside xdp xmit
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Mon, 06 Mar 2023 08:49:24 -0800
In-Reply-To: <20230306041535.73319-1-xuanzhuo@linux.alibaba.com>
References: <20230306041535.73319-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-06 at 12:15 +0800, Xuan Zhuo wrote:
> If the queue of xdp xmit is not an independent queue, then when the xdp
> xmit used all the desc, the xmit from the __dev_queue_xmit() may encounte=
r
> the following error.
>=20
> net ens4: Unexpected TXQ (0) queue failure: -28
>=20
> This patch adds a check whether sq is full in XDP Xmit.
>=20
> Thanks.
>=20
> Xuan Zhuo (2):
>   virtio_net: separate the logic of checking whether sq is full
>   virtio_net: add checking sq is full inside xdp xmit
>=20
>  drivers/net/virtio_net.c | 78 ++++++++++++++++++++++++----------------
>  1 file changed, 47 insertions(+), 31 deletions(-)
>=20
> --
> 2.32.0.3.g01195cf9f
>=20

Series looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

