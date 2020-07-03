Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4BC21404C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgGCUWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:22:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726147AbgGCUWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 16:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593807769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0bOOykRbSP71Y9q/RxlG+HHNAGiz0/Va3IAVPaB7pI=;
        b=evM5WhYp4SZYvFiOA7VaOjELV1FA0/qxRuijxzbZOJTYxg/TsON8xH9gXHNs0Qq4U35uol
        6AR5G/oYNLIdFi0YbfxX5ZkgGMd0MshSNQKwvyGUtRsDz7gGau4/r2+wHEirYBbunKSmpm
        YC0LgO0Q5BCvGYxHTEglFHqDm5q54rk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-LNbCfNvSMfOuzlhZOXX61w-1; Fri, 03 Jul 2020 16:22:47 -0400
X-MC-Unique: LNbCfNvSMfOuzlhZOXX61w-1
Received: by mail-qk1-f197.google.com with SMTP id z1so12265066qkz.3
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 13:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=s0bOOykRbSP71Y9q/RxlG+HHNAGiz0/Va3IAVPaB7pI=;
        b=J83uwNmSuIl8DRehBAQgkvlraEb5yfSkl8wSTua3aHphIUKWk5tHbEtT2ATlreBzxb
         ra45j0rksTBwmgRM98Hp4WLn/dW44WMdHiVR4FBOahJCAGlUSUsbKxP43Q5te+1i/TnZ
         0nDEHEDEavPBE6wQrWcUa5SobLlgH/xgPdqW2q/3kj8K4R1lSP0shZYHpankx0777msk
         +4ruIaUiib5Tt8NSikVglZTH6667Bl/ZiDvABgZ5oRApitjqfw0zpy+3iIFEEshFMxhe
         fd1Cz40SKhyX2BGiwuFCXPaOFUUfLV/Icyp+vF9bkOUYdshBQonIfceJcYxfM6GkY7Ck
         4scA==
X-Gm-Message-State: AOAM531Ni8TN/R6FkuOOx8AK+jhPxhAaZALAno8+RHMdEu6dl7zZh48p
        SMiHj56ELpQ7vIsvxDwbJ4PLoRb6fGd8NZPqP5htUXTfECOkdp9xHrH/FlPUhq4Fle+tLatqGHc
        FxzOjZrO/I4w1qxyA
X-Received: by 2002:a37:aa87:: with SMTP id t129mr36885108qke.70.1593807766898;
        Fri, 03 Jul 2020 13:22:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwH9YKEGxb7TOlmxT4oJXSsUaaopLdXHc7EcazKMQ/EVfpCBvoYZGTZl1h2NM5CjHOoSan96w==
X-Received: by 2002:a37:aa87:: with SMTP id t129mr36885095qke.70.1593807766692;
        Fri, 03 Jul 2020 13:22:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t48sm13060329qtb.50.2020.07.03.13.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 13:22:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0155B1804A8; Fri,  3 Jul 2020 22:22:42 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        cake@lists.bufferbloat.net,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, davem@davemloft.net
Subject: Re: [Cake] [PATCH net v2] sched: consistently handle layer3 header accesses in the presence of VLANs
In-Reply-To: <85sge82w34.fsf@mojatatu.com>
References: <20200703152239.471624-1-toke@redhat.com> <85sge82w34.fsf@mojatatu.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Jul 2020 22:22:42 +0200
Message-ID: <87k0zkmjql.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roman Mashak <mrv@mojatatu.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>
>
> [...]
>
>> +/* A getter for the SKB protocol field which will handle VLAN tags cons=
istently
>> + * whether VLAN acceleration is enabled or not.
>> + */
>> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_=
vlan)
>> +{
>> +	unsigned int offset =3D skb_mac_offset(skb) + sizeof(struct ethhdr);
>> +	__be16 proto =3D skb->protocol;
>> +	struct vlan_hdr vhdr, *vh;
>
> Nit: you could move vhdr and *vh definitions inside the while loop,
> because of their inner scope use.

Sure, can do.

-Toke

