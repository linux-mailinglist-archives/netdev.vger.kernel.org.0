Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807E553B9A4
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiFBN1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 09:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiFBN1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 09:27:36 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8142531523;
        Thu,  2 Jun 2022 06:27:32 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so2773389wms.3;
        Thu, 02 Jun 2022 06:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l8W+7tcFTmWgcZkmqtvEAURZZKd0U2SDl09JGSg/xJY=;
        b=EqF2c9DqGwXxEBxvnMScQ+ELXNccLj4Uv/g2mPawAj6APVYuwRlURI25YdBdFtNhb2
         hm5s4r8nxVxYtjk7B4r8ZAQ4vzbuC2C1ydfNdoH5WwtOfWly2jlVVtP9j8BfvaCSs1zY
         nqmTz20aaOy0p3CIvz4sk1WFXq5uP46hqsPKSW8g/jpwQ3zA1fVMgwKOmTVsQKYqRUoz
         R6xSU+xTqa6fVeRBfNS8XUZ1bYaAXHpbc8DlW9jiaEO+GeOPURDfDYYBl0TOUayMWdkn
         TdY+VKI1tfIWc9GfRq+WeG2qxLiGye2M4PXQ7ChXlB00w0wKbPA2c1U4iANB/s/HIAbj
         C0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8W+7tcFTmWgcZkmqtvEAURZZKd0U2SDl09JGSg/xJY=;
        b=3hnnY4AokHVbK7B1CC9/gkqa0K+thzVErwJaxaQUVI2hSXk1DtoIRFajQ7x4Mc43P4
         sfaGT94eM48H5/0sCe6oOXzEon/ScAR4mh6TkDG0wpOnC0fydCUsOuWsxZLaBBMNXmmM
         HyAAjuEqeJThAAUtgdq6VECB/6DiLz9shftB8CP2OphbiIapdTWh3gzPqgaDmchmZcbd
         nffC302Pb3csnnQgVTC0xUdHLwG2CU3qPagIG2k7LsODIookV3hFr5MuY98N34Qi8z27
         qkAH0d9RvFyI8d2cIDtODM3GuEGXr677LHKWPxB0rffR6lfmU2+StrJrOVbrFbgSyWD+
         eWyQ==
X-Gm-Message-State: AOAM530rUVqJSHNaMYdePpvPtorPhRgdzXNjk3wjq0dP5xmsDha+8JXM
        atJApjj5/0aB0oTpumeFn7RVaxcM/Dil5/fsgdQ=
X-Google-Smtp-Source: ABdhPJwYupf43+H7wFwlwquLKLXu/Ei58WabOVVaZSXOqm1N2/bD1VaLi6h42LIL3W3Xt9RG1iGYtvyot1MCGIgpLGw=
X-Received: by 2002:a05:600c:3d94:b0:39c:1c04:3191 with SMTP id
 bi20-20020a05600c3d9400b0039c1c043191mr3899511wmb.171.1654176450981; Thu, 02
 Jun 2022 06:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <86sfov2w8k.fsf@gmail.com> <YpCgxtJf9Qe7fTFd@shredder>
 <86sfoqgi5e.fsf@gmail.com> <YpYk4EIeH6sdRl+1@shredder> <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org> <86sfonjroi.fsf@gmail.com>
 <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org> <YpiTbOsh0HBMwiTE@shredder>
 <86mtevjmie.fsf@gmail.com> <YpiqlziXDCg/1FJH@shredder>
In-Reply-To: <YpiqlziXDCg/1FJH@shredder>
From:   Hans S <schultz.hans@gmail.com>
Date:   Thu, 2 Jun 2022 15:27:19 +0200
Message-ID: <CAKUejP5NiPYre8qAJKqJ0SOxQ_DtXHt6q6ze6gr=Xx6VGc8xsA@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
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

Yes, that sounds much like the case. So the replace of course just
modifies the SW fdb entry, and then it just uses port_fdb_add() to
replace HW entry I assume, which then in my case triggers
SWITCHDEV_FDB_DEL_TO_BRIDGE as the locked entry is removed.
So I should not send the SWITCHDEV_FDB_DEL_TO_BRIDGE message when
removing the locked entry from port_fdb_add() function...

(note: having problems with smtp.gmail.com...)


On Thu, Jun 2, 2022 at 2:18 PM Ido Schimmel <idosch@nvidia.com> wrote:
>
> On Thu, Jun 02, 2022 at 02:08:41PM +0200, Hans Schultz wrote:
> > >
> > > I think Hans is testing with mv88e6xxx which dumps entries directly from
> > > HW via ndo_fdb_dump(). See dsa_slave_port_fdb_do_dump() which sets
> > > NTF_SELF.
> > >
> > > Hans, are you seeing the entry twice? Once with 'master' and once with
> > > 'self'?
> > >
> >
> > When replacing a locked entry it looks like this:
> >
> > # bridge fdb show dev eth6 | grep 4c
> > 00:4c:4c:4c:4c:4c vlan 1 master br0 extern_learn offload locked
> >
> > # bridge fdb replace 00:4c:4c:4c:4c:4c dev eth6 vlan 1 master static ; bridge fdb show dev eth6 | grep 4c
> > 00:4c:4c:4c:4c:4c vlan 1 self static
>
> This output means that the FDB entry was deleted from the bridge driver
> FDB.
>
> >
> > The problem is then that the function
> > br_fdb_find_rcu(br,eth_hdr(skb)->h_source, vid);
> > , where the h_source and vid is the entry above, does not find the entry.
> > My hypothesis was then that this is because of the 'self' flag that I
> > see.
>
> br_fdb_find_rcu() does a lookup in the bridge driver FDB, but per the
> output above, the entry isn't there for some reason. It's only in HW.
>
> Can it be that you driver is deleting these entries from the bridge
> driver FDB via SWITCHDEV_FDB_DEL_TO_BRIDGE for some reason?
>
> >
> > I am thinking that the function dsa_slave_port_fdb_do_dump() is only for
> > debug, and thus does not really set any flags in the bridge modules FDB,
> > but then I don't understand why the above find function does not find
> > the entry?
