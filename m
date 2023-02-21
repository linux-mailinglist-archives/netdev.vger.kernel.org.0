Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A953B69D924
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 04:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjBUDGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 22:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjBUDGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 22:06:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31B3234C9
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 19:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676948757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BptwBvQo4kKBIsOLYiTztpRLcZRrp4WC3qd5w6Jr6p0=;
        b=N0gNpQeEuoISpxBVWyaDMYsHVfg8YTppfT1t2P7PfeGzlMNe6U3O6HtQflQnl95sM/5kbn
        n0TEf2zHXY64GuXCUWesP2jcYDwg2OCwFUIbh958yVEh9nB3UDwG5jlbOfHZD+cqWq5s1u
        LO9Pw1Z8LDqPME+68g2baLKFTtxW6fk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-XMGbQcDOMyaagCBmzoH7gw-1; Mon, 20 Feb 2023 22:05:56 -0500
X-MC-Unique: XMGbQcDOMyaagCBmzoH7gw-1
Received: by mail-ed1-f72.google.com with SMTP id g24-20020a056402321800b004ace77022ebso3978139eda.8
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 19:05:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BptwBvQo4kKBIsOLYiTztpRLcZRrp4WC3qd5w6Jr6p0=;
        b=ESMZieo3b+5+6ww4Z4QHgB+N5bS1R5DXMfQaSQVPanwO9nmoOCm3F5++s7DNvefpDp
         KyzLwaKAWFUiGYIbtQRZDtzRlQRDqOEe4eNvSQjIlK03Uv24HHY070zuyfG1163odAPI
         eM+YT/nhGE02GPEkkbKZWNTOw6K9tOtLXb7bvJ5P4n2xs5Yl+KMRJWX+W5FZwGyJemOB
         D0onX7ivmd6bpqZlv7sopVxannwJJr1Kl3OMiHaoHkHwvgFQbq2FPHLUDhp3MdstnLu2
         BHAOcKWMmGZoFDSF+4+KNMoiceMF7Usbnv+5+elGAe9bjjUpVyfzASxtk8rGQWaG8FkW
         p5Eg==
X-Gm-Message-State: AO0yUKVY3KpLvaYh4LNTGDIpWdQzmTxhiDwscWsUc6CbnX0MVNdysx5e
        VTx2BJVeGXc/RBkEqDyydZImAvvqtAsUDI+dP3gEh1eqVdpWVXPbsjaDgAxrl6U5mMJ1UOupXXx
        yzUfyL4oDUfIcHIVIM0bNecwAktdidrCw
X-Received: by 2002:a17:906:5158:b0:883:ba3b:eb94 with SMTP id jr24-20020a170906515800b00883ba3beb94mr4978143ejc.3.1676948755273;
        Mon, 20 Feb 2023 19:05:55 -0800 (PST)
X-Google-Smtp-Source: AK7set9jVHY4ucufPijCs6AjzBOPHfLncdKqZbq5tEHTs0STTs/YYj17Ofabhrxm4vpCviGQ73FfqHt6h/syeV5b/P0=
X-Received: by 2002:a17:906:5158:b0:883:ba3b:eb94 with SMTP id
 jr24-20020a170906515800b00883ba3beb94mr4978134ejc.3.1676948755047; Mon, 20
 Feb 2023 19:05:55 -0800 (PST)
MIME-Version: 1.0
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
 <20221129160046.538864-2-miquel.raynal@bootlin.com> <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
 <20230206101235.0371da87@xps-13> <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
 <20230210182129.77c1084d@xps-13> <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
 <20230213111553.0dcce5c2@xps-13> <CAK-6q+jP55MaB-_ZbRHKESgEb-AW+kN3bU2SMWMtkozvoyfAwA@mail.gmail.com>
 <20230214152849.5c3d196b@xps-13> <CAK-6q+i-QiDpFptFPwDv05mwURGVHzmABcEn2z2L9xakQwgw+w@mail.gmail.com>
 <20230217095251.59c324d0@xps-13> <CAK-6q+ikVP2eWpT5xRkiJn_JoenmD6D5+xcc2RwwXTfC-zsobw@mail.gmail.com>
In-Reply-To: <CAK-6q+ikVP2eWpT5xRkiJn_JoenmD6D5+xcc2RwwXTfC-zsobw@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 20 Feb 2023 22:05:43 -0500
Message-ID: <CAK-6q+h6ZKvw5qR7yb2bvRrLvqUw0Mf5zVuh5-=fF5OgwJOr+A@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning requests
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 20, 2023 at 9:54 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Feb 17, 2023 at 3:53 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > >
> > > ok, I am curious. Probably it is very driver/device specific but yea,
> > > HardMAC needs to at least support what 802.15.4 says, the rest is
> > > optional and result in -ENOTSUPP?
> >
> > TBH this is still a gray area in my mental model. I'm not sure what
> > these devices will really offer in terms of interfaces.
>
> ca8210 is one. They use those SAP-commands (MCPS-SAP and MLME-SAP)
> which are described by 802.15.4 spec... there is this cfg802154_ops
> structure which will redirect netlink to either SoftMAC or HardMAC it
> should somehow conform to this...
> However I think it should be the minimum functionality inside of this,
> there might be a lot of optional things which only SoftMAC supports.
> Also nl802154 should be oriented to this.
>
> Are you agreeing here?

it's just not nl802154/cfg802154 also sending specific kind of frames
out added to cfg802154 which we don't have yet inside of this
"callback structure to interfacing SoftMAC or HardMAC".

- Alex

