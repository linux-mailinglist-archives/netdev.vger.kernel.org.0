Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5654D3DEB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbiCJAOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbiCJAOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:14:51 -0500
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578595BD32;
        Wed,  9 Mar 2022 16:13:51 -0800 (PST)
Received: by mail-vk1-xa2c.google.com with SMTP id i18so2142113vkr.13;
        Wed, 09 Mar 2022 16:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4hJmFhM88IZ+dfQepZO8uH6DD9gUdFnEB+hz6SedP+4=;
        b=CKEl89vJadtt17Npn5H8NJmrgnK8fyZNwKibXP9BpwRPr11NXt4jtMrvJLofvOidQw
         M7AX4xdrWksfffU9MQhthfVbt70ec752LzrA4GXUZQc9zXr0DPMYi3/gFpd1QzUSV2F8
         0R/fnWN6bT+B30PkySXzHjsQ+EwcBpRPkJwvlRKABIAA4jpYgbgoXCXK1oUwgQq8mDWf
         4lYSekEwWiXGOwdPAamgVKPNNnAiCQki9IdaGB6FkTkn6F4HgmjoLVp2Nv5J90OSR11v
         nDiYFrCXeS2Ja+UhTIFlNZE0evb5pTd0cvRjTJwmiMbfXUneS8GjDIdY96SHMHedW3jE
         k7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4hJmFhM88IZ+dfQepZO8uH6DD9gUdFnEB+hz6SedP+4=;
        b=Hpz0WbPHkJP9U/9+Q5oYBWHKdcSE9CWftI83Qbj57SYRRLRju4s3lgpoakFozCkXW2
         OyhsRYeXP+vxFmfOi5c6Xk5nAmFVFXzTeax+J0Q+ABmFolpRXqaR5ou5UhXKIZSPbZz6
         zrZRisIwZhvzhnhK5b+MNRWH1VMSq61xbgeJG3oN0n2nx0BflxokDN0u8Hg6qLgLhT24
         4/cHqlFzq0QGAURViMqGdVPHRxJ2Usfr7w09Vnm0d/iGV54QkWOHqd6ZXiaij2gtbshq
         4qGOspAItLjdBUiuSqkZ0K04NW4akXus8Uhtlb8GYKmjDr/fpgR82G5LuNO4xmF/hbnU
         JN+g==
X-Gm-Message-State: AOAM530UAsYK/FAM43GYqrtFP39v4X89afo3xso/hcO+eMLIcXRHYPhi
        DwrfnXn0w5vepKt0zhji58Mdw3LokC0EU6yKhC0=
X-Google-Smtp-Source: ABdhPJyptdgvj8ett73F9nvvYiUqg+AxIF/iWvCFyBgWjG8+E6Ns3O9znnHnhLgZd7vGT5fUEASvY4iuM0IVyMSzkQQ=
X-Received: by 2002:ac5:c8bc:0:b0:337:b6b6:7607 with SMTP id
 o28-20020ac5c8bc000000b00337b6b67607mr1333908vkl.1.1646871230374; Wed, 09 Mar
 2022 16:13:50 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-7-ricardo.martinez@linux.intel.com> <CAHNKnsSZ_2DAPQRsa45VZZ1UYD6mga_T0jfX_J+sb1HNCwpOPA@mail.gmail.com>
 <5cf76041-77be-2651-f421-ad2521966570@linux.intel.com>
In-Reply-To: <5cf76041-77be-2651-f421-ad2521966570@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Thu, 10 Mar 2022 03:13:39 +0300
Message-ID: <CAHNKnsQ2mKzVNyH+cyw4k+U1PXNz-dB8a0YfqSYqtBAROAwAmg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 06/13] net: wwan: t7xx: Add AT and MBIM WWAN ports
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 9, 2022 at 3:02 AM Martinez, Ricardo
<ricardo.martinez@linux.intel.com> wrote:
> On 3/6/2022 6:56 PM, Sergey Ryazanov wrote:
>> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
>> <ricardo.martinez@linux.intel.com> wrote:
>>> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>>>
>>> Adds AT and MBIM ports to the port proxy infrastructure.
>>> The initialization method is responsible for creating the corresponding
>>> ports using the WWAN framework infrastructure. The implemented WWAN por=
t
>>> operations are start, stop, and TX.
>> [skipped]
>>
>>> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *s=
kb)
>>> +{
>>> +       struct t7xx_port *port_private =3D wwan_port_get_drvdata(port);
>>> +       size_t actual_len, alloc_size, txq_mtu =3D CLDMA_MTU;
>>> +       struct t7xx_port_static *port_static;
>>> +       unsigned int len, i, packets;
>>> +       struct t7xx_fsm_ctl *ctl;
>>> +       enum md_state md_state;
>>> +
>>> +       len =3D skb->len;
>>> +       if (!len || !port_private->rx_length_th || !port_private->chan_=
enable)
>>> +               return -EINVAL;
>>> +
>>> +       port_static =3D port_private->port_static;
>>> +       ctl =3D port_private->t7xx_dev->md->fsm_ctl;
>>> +       md_state =3D t7xx_fsm_get_md_state(ctl);
>>> +       if (md_state =3D=3D MD_STATE_WAITING_FOR_HS1 || md_state =3D=3D=
 MD_STATE_WAITING_FOR_HS2) {
>>> +               dev_warn(port_private->dev, "Cannot write to %s port wh=
en md_state=3D%d\n",
>>> +                        port_static->name, md_state);
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       alloc_size =3D min_t(size_t, txq_mtu, len + CCCI_HEADROOM);
>>> +       actual_len =3D alloc_size - CCCI_HEADROOM;
>>> +       packets =3D DIV_ROUND_UP(len, txq_mtu - CCCI_HEADROOM);
>>> +
>>> +       for (i =3D 0; i < packets; i++) {
>>> +               struct ccci_header *ccci_h;
>>> +               struct sk_buff *skb_ccci;
>>> +               int ret;
>>> +
>>> +               if (packets > 1 && packets =3D=3D i + 1) {
>>> +                       actual_len =3D len % (txq_mtu - CCCI_HEADROOM);
>>> +                       alloc_size =3D actual_len + CCCI_HEADROOM;
>>> +               }
>>
>> Why do you track the packet number? Why not track the offset in the
>> passed data? E.g.:
>>
>> for (off =3D 0; off < len; off +=3D chunklen) {
>>      chunklen =3D min(len - off, CLDMA_MTU - sizeof(struct ccci_header);
>>      skb_ccci =3D alloc_skb(chunklen + sizeof(struct ccci_header), ...);
>>      skb_put_data(skb_ccci, skb->data + off, chunklen);
>>      /* Send skb_ccci */
>> }
>
> Sure, I'll make that change.
>
>>> +               skb_ccci =3D __dev_alloc_skb(alloc_size, GFP_KERNEL);
>>> +               if (!skb_ccci)
>>> +                       return -ENOMEM;
>>> +
>>> +               ccci_h =3D skb_put(skb_ccci, sizeof(*ccci_h));
>>> +               t7xx_ccci_header_init(ccci_h, 0, actual_len + sizeof(*c=
cci_h),
>>> +                                     port_static->tx_ch, 0);
>>> +               skb_put_data(skb_ccci, skb->data + i * (txq_mtu - CCCI_=
HEADROOM), actual_len);
>>> +               t7xx_port_proxy_set_tx_seq_num(port_private, ccci_h);
>>> +
>>> +               ret =3D t7xx_port_send_skb_to_md(port_private, skb_ccci=
);
>>> +               if (ret) {
>>> +                       dev_kfree_skb_any(skb_ccci);
>>> +                       dev_err(port_private->dev, "Write error on %s p=
ort, %d\n",
>>> +                               port_static->name, ret);
>>> +                       return ret;
>>> +               }
>>> +
>>> +               port_private->seq_nums[MTK_TX]++;
>>
>> Sequence number tracking as well as CCCI header construction are
>> common operations, so why not move them to t7xx_port_send_skb_to_md()?
>
> Sequence number should be set as part of CCCI header construction.
>
> I think it's a bit more readable to initialize the CCCI header right
> after the corresponding skb_put(). Not a big deal, any thoughts?

I do not _think_ creating the CCCI header in the WWAN or CTRL port
functions is any good idea. In case of stacked protocols, each layer
should create its own header, pass the packet down the stack, and then
a next layer will create a next header.

In case of the CTRL port, this means that the control port code should
take an opaque data block from an upper layer (e.g. features request),
prepend it with a control msg header, and pass it down the stack to
the port proxy layer, where the CCCI header will be prepended.

In case a WWAN port, all headers are passed from user space, so there
=D1=88=D1=8B nothing to prepend. And the only remaining function is to frag=
ment
a user input, and then pass all  the fragments to the port proxy
layer, where the CCCI header will be prepended.

This way, you do not overload the CTRL/WWAN port with code of other
protocols (i.e. CCCI), reduce code duplication. Which in itself
improves the code maintainability and future development. Creating a
CCCI header at the WWAN port layer is like forcing a user to manually
create IP and UDP headers before writing a data block into a network
socket :)

Anyway, it is up to you to decide exactly how to create headers and
assign sequence numbers. I just wanted to point out the code
inconsistency. It does not make the code wrong, it just makes the code
look stranger.

> Note that the upcoming fw update feature doesn't require a CCCI header,
> so we could rename the TX function as t7xx_port_send_ccci_skb_to_md(),
> this would give a hint that it is taking care of the CCCI header.

Does this mean the firmware upgrade does not utilize the channel id,
and just pushes data directly to a specific CLDMA queue? In that case
it looks like the firmware upgrade code needs to entirely bypass the
port proxy layer and communicate directly with CLDMA. Isn't it?

>>> +       }
>>> +
>>> +       dev_kfree_skb(skb);
>>> +       return 0;
>>> +}

--=20
Sergey
