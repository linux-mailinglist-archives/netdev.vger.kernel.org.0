Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1E34217B
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCSQLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhCSQLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 12:11:13 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2B3C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 09:11:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f8so568281pgi.9
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 09:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WLipTIgsxq07Cj5tFotwTGWIVP97RFZLRby1vgsrO0I=;
        b=KVpLd0KqWczndGzDXuHbaF3YmUqchoYziMcwZCtr/4kUNDBx57iBzIFGlJBq4Rcr2H
         Wccm6YPUM131TL76NAA02XNufeLrITK4BgURwmSj7ikp6R5LExLT5R0XHWpXEM1BeyJ+
         R4UMFb6Yos5PglPv2bnSxhciuz2sG1WoAxtyApLd9eXBJO9gMJ35rEJi11FKEYRGfhdf
         kfdiQ0FRTesART61N5ps0PrzThQ1YgijuuE+4zh32ER7HjGnBiI7FjVSgagQ9tlU4fPg
         9aIrsK3092f/AZm9ED+mk0vjS5b0SHR6rvFjl375yUorVlhPESNvpAlYEgUJlKcTbUgh
         DTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WLipTIgsxq07Cj5tFotwTGWIVP97RFZLRby1vgsrO0I=;
        b=QoxuibDjEgeL+PC/B8rHBhvnPoQOPL0A7dkAFobeyPnUbN3EEuGoR4Mzmu559TvSxS
         ipRwyU0YdNsLwAT95nqrM064JUcErGh3xhZmtfnsmFnNwohaLh3ceVil9JrcAWqxyPdi
         2hu1J208+ZPZNMrJ/kx878r9/wHFUF5lyYtEIcGNSU1DXQ4Wpi6NgGdOJsqFF5lX6xjT
         ThW9kAnuKnCUv+Sck+aD4kdT/cKyOuOqwPT83r0kVzfGpTeGKULyiwJ3Y4C+7lCCKndH
         gdJIl+eO9qynbtFCDtp0SM6EVfJ539xtUWNQBPARDJQ+oxkONR16j7TEsl/BVlECl6X3
         P7Iw==
X-Gm-Message-State: AOAM530+Vu04ZnoBA3C2R2F5DXDLyS2vzF+KUoXuYOLvbn3h5xHV/NqC
        e63pNyJwqYXnKuMBKcrQd7BzESn/uoEcaEYM
X-Google-Smtp-Source: ABdhPJx9qs6HCwzP9RqAhnIAkkClzDRetJ3uHksisgvWpazzPw7YEMvLbxF1023SzfsNHkPDub7y8A==
X-Received: by 2002:aa7:824e:0:b029:20a:3a1:eeda with SMTP id e14-20020aa7824e0000b029020a03a1eedamr9758802pfn.71.1616170273391;
        Fri, 19 Mar 2021 09:11:13 -0700 (PDT)
Received: from ?IPv6:2600:8801:130a:ce00:d905:609a:780b:479? ([2600:8801:130a:ce00:d905:609a:780b:479])
        by smtp.gmail.com with ESMTPSA id j22sm5220633pjz.3.2021.03.19.09.11.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Mar 2021 09:11:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v3] icmp: support rfc5837
From:   Ishaan Gandhi <ishaangandhi@gmail.com>
In-Reply-To: <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
Date:   Fri, 19 Mar 2021 09:11:06 -0700
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        willemb@google.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you. Would it be better to do instead:

+	if_index =3D skb->skb_iif;

or

+	if_index =3D ip_version =3D=3D 4 ? inet_iif(skb) : skb->skb_iif;

> On Mar 19, 2021, at 7:55 AM, David Ahern <dsahern@gmail.com> wrote:
>=20
> On 3/17/21 4:19 PM, ishaangandhi wrote:
>> +void icmp_identify_arrival_interface(struct sk_buff *skb, struct net =
*net, int room,
>> +				     char *icmph, int ip_version)
>> +{
>> +	unsigned int ext_len, orig_len, word_aligned_orig_len, offset, =
extra_space_needed,
>> +		     if_index, mtu =3D 0, name_len =3D 0, =
name_subobj_len =3D 0;
>> +	struct interface_ipv4_addr_sub_obj ip4_addr_subobj =3D {.addr =3D =
0};
>> +	struct interface_ipv6_addr_sub_obj ip6_addr_subobj;
>> +	struct icmp_extobj_hdr *iio_hdr;
>> +	struct inet6_ifaddr ip6_ifaddr;
>> +	struct inet6_dev *dev6 =3D NULL;
>> +	struct icmp_ext_hdr *ext_hdr;
>> +	char *name =3D NULL, ctype;
>> +	struct net_device *dev;
>> +	void *subobj_offset;
>> +
>> +	skb_linearize(skb);
>> +	if_index =3D inet_iif(skb);
>=20
> inet_iif is an IPv4 helper; it should not be used for v6 skb's.
>=20

