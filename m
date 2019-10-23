Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54302E2228
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732343AbfJWRz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:55:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36251 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731673AbfJWRz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:55:28 -0400
Received: by mail-wm1-f66.google.com with SMTP id c22so11421455wmd.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 10:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MR7X5cmUMbAGyhVMpKWag4LE423qdgpRZ6IdJUs55wA=;
        b=uqhMc1a63bKmXWyKOABmgVPjW27vGN/zwMb4NXvxGYn8/VE1uX8grEqp+Pbe2qAV0J
         Zcns/FJwXGsNA120ov9re2KZ9YWZg8keiacR8VdO+UOiaT1H0jsFBFBQDJPe2Zs1crIf
         W4yZYqvXGMh9tSyG7k0JuSX0mQrcrncOl06PjDp51eMJwzVB1InHOHOrHZbuJnXIREVp
         crB+33+IwqGkJPQSqVZ3MS+yG13myXzL4cZWEV3+xOp/9lXXCctFoNLQ1C4L56Lsegfu
         YwryuamkB61A0u50IbQhGE5SKKUChBnZCnmvDvXETWJlBuvoEWbNdc4VcKVN2m4750yn
         lADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MR7X5cmUMbAGyhVMpKWag4LE423qdgpRZ6IdJUs55wA=;
        b=Vty08/h3qrtb0hqYugnPPAgZ5Tv/tEC75SE2OaXufav4Nen/+1wQ+GbCjJQIrxEGiG
         BP2+pDuprkbSAMQRIJ3XGQWbSpgafqYANh6Uf9jYWoB8qz6hi+ViLcrO8bR5xPFXOZ/7
         Bacb+krJ0vq6ydNwVFXc3iQo6bbnx6mDXNXT3E7dHpn4c9ZAqrWjiPXl6xTnayno8/9P
         Kp5ly3Ot+ranrZGk76QAc/QRvLsb/q0DVMnG66kZ9rlvzKGixGlmrawOrQOt9/xcHcSk
         OTclufWL4wASeLVMQBg2IGy/rtUnc+MkYJIXtLxc0sxH/HL8pfJCzt6vZGRRmTztbBIj
         9YcA==
X-Gm-Message-State: APjAAAVeUQVmqUZ8pYhsD0aUQNP6ETeTnQhUhZgB500mpCm3218ONVFN
        4fOnZpr5ckfdXDk8CYvfGGUDrA==
X-Google-Smtp-Source: APXvYqz/B9MnKi/QliYF4Oj44EBnIW/k+njNbJ+2Om+Kztd3MM3IhkLqJRcLcz8RJ+X1b/mfdRvbjw==
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr1069919wmg.109.1571853326343;
        Wed, 23 Oct 2019 10:55:26 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id d8sm9238615wrr.71.2019.10.23.10.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 10:55:25 -0700 (PDT)
Date:   Wed, 23 Oct 2019 19:55:23 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] flow_dissector: extract more ICMP
 information
Message-ID: <20191023175522.GB28355@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-4-mcroce@redhat.com>
 <20191023100009.GC8732@netronome.com>
 <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 12:53:37PM +0200, Matteo Croce wrote:
> On Wed, Oct 23, 2019 at 12:00 PM Simon Horman
> <simon.horman@netronome.com> wrote:
> > On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> > > +     switch (ih->type) {
> > > +     case ICMP_ECHO:
> > > +     case ICMP_ECHOREPLY:
> > > +     case ICMP_TIMESTAMP:
> > > +     case ICMP_TIMESTAMPREPLY:
> > > +     case ICMPV6_ECHO_REQUEST:
> > > +     case ICMPV6_ECHO_REPLY:
> > > +             /* As we use 0 to signal that the Id field is not present,
> > > +              * avoid confusion with packets without such field
> > > +              */
> > > +             key_icmp->id = ih->un.echo.id ? : 1;
> >
> > Its not obvious to me why the kernel should treat id-zero as a special
> > value if it is not special on the wire.
> >
> > Perhaps a caller who needs to know if the id is present can
> > check the ICMP type as this code does, say using a helper.
> >
> 
> Hi,
> 
> The problem is that the 0-0 Type-Code pair identifies the echo replies.
> So instead of adding a bool is_present value I hardcoded the info in
> the ID field making it always non null, at the expense of a possible
> collision, which is harmless.

Sorry, I feel that I'm missing something here.

My reading of the code above is that for the cased types above
(echo, echo reply, ...) the id is present. Otherwise it is not.
My idea would be to put a check for those types in a helper.

I do agree that the override you have used is harmless enough
in the context of the only user of the id which appears in
the following patch of this series.


Some other things I noticed in this patch on a second pass:

* I think you can remove the icmp field from struct flow_dissector_key_ports

* I think that adding icmp to struct flow_keys should be accompanied by
  adding ICMP to flow_keys_dissector_symmetric_keys. But I think this is
  not desirable outside of the bonding use-case and rather
  the bonding driver should define its own structures that
  includes the keys it needs - basically copies of struct flow_keys
  and flow_keys_dissector_symmetric_keys with some modifications.

* Modifying flow_keys_have_l4 affects the behaviour of
  skb_get_hash_flowi6() but there is not a corresponding update
  to flow_keys_have_l4(). I didn't look at all the other call sites
  but it strikes me that this is a) a wide-spread behavioural change
  and b) is perhaps not required for the bond-use case.
