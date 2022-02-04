Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415A4A93E7
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 07:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242309AbiBDGUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 01:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiBDGUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 01:20:31 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CBDC061714;
        Thu,  3 Feb 2022 22:20:30 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id r15-20020a4ae5cf000000b002edba1d3349so3714221oov.3;
        Thu, 03 Feb 2022 22:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yqq5nruFRyr0PY21hycsFvKd9gLbPgg5hxJ4K19gBbA=;
        b=ZekAY95ELU3OpUebh3PKjRScyZXRTZjVOqdJ/pVqH8+yILD+n3980r/NIXvjKyYF9D
         ZD7TwFShY5MpJQbdKMxGupo6YVo4CRLl9kEdgsVXUe4owq7IC6TurbRSJDBnDxhs3ccV
         p4gICUjong+VuXXPNy+pPKpqA6hX7zo6ClDkDfp3s+9splwk+pEhNIErIAoe6R4dcMgJ
         j065RWmr3ipjd1ENxmMk4OV7l3qUTfbV2wj4WHusVXpu840bHDMJz+Hv93w82cVPjJh3
         DWVdxCu2ZeW/OecCCX17E7g94J3qVLU78s1sAVKkKrkGxvUwd7oL+5Gab9dKd6CNtu5N
         DYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yqq5nruFRyr0PY21hycsFvKd9gLbPgg5hxJ4K19gBbA=;
        b=q+L6EMFt7kLvMGa2m0ULg4DPV5Q0zQ7GGhA983TFAol/zIV2t0oQKqs7ATuJHwA1zu
         MFRHIsdv/33GQXyx9iC99nK4vs+X5Pbx+bUv5GJOrh0ChBYFvU7Il1sEsjKjLtbwhu/t
         LuDcr79UIglVJVJphlDIWHlEMxkepP8zvoCXdIz3jGK3isjPmBhTM9sHbWs3AlFxqW6e
         IJ35C98YEoOUcJG79loz4AyrXiyEDhWzCth6PoymH8XV3ooC0BF77piCacQGiIJFMGz0
         HZ4Z+o7bZ7c+Oo4ou7FUOMghjuGLBlM6GYb+wW/Mq+aLIv6AavAlnfxK/Y59GPf2+U/o
         6V/g==
X-Gm-Message-State: AOAM533DD9GfjyOK0AgggfryU6vLoW7ie+M33aGPTj5XqdYP34N3F5N1
        K3VtxkaC873uGq47+kz/mw==
X-Google-Smtp-Source: ABdhPJxh8V8vuXYD6GwKQT3fEgtoNoK0zH4HGnRmcDBB3TCxu3B3Tk0tCHXr4uFOkW3Y33Lpluw+IQ==
X-Received: by 2002:a05:6870:c343:: with SMTP id e3mr253761oak.54.1643955628869;
        Thu, 03 Feb 2022 22:20:28 -0800 (PST)
Received: from smtpclient.apple ([191.177.181.165])
        by smtp.gmail.com with ESMTPSA id t43sm251788oap.1.2022.02.03.22.20.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 22:20:28 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.40.0.1.81\))
Subject: Re: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording
 for BTFGen
From:   Rafael David Tinoco <rafaeldtinoco@gmail.com>
In-Reply-To: <CAEf4BzagOBmVbrPOnSwthOxt7CYoqNTuojbtmgskNa_Ad=8EVQ@mail.gmail.com>
Date:   Fri, 4 Feb 2022 03:20:22 -0300
Cc:     =?utf-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
X-Mao-Original-Outgoing-Id: 665648422.115451-cac6df2b497e4f0fe853b116de2138d5
Content-Transfer-Encoding: 7bit
Message-Id: <8846F5AD-CFD3-4F32-B9C5-E36AB38C37DF@gmail.com>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
 <20220128223312.1253169-7-mauricio@kinvolk.io>
 <CAEf4BzZu-u1WXGScPZKVQZc+RGjmnYm45mcOGkzXyFLMKS-5gA@mail.gmail.com>
 <CAHap4zv+bLA4BB9ZJ7RXDCChe6dU0AB3zuCieWskp2OJ5Y-4xw@mail.gmail.com>
 <CAEf4BzagOBmVbrPOnSwthOxt7CYoqNTuojbtmgskNa_Ad=8EVQ@mail.gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
X-Mailer: Apple Mail (2.3693.40.0.1.81)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> As in, do you substitute forward declarations for types that are
>>> never directly used? If not, that's going to be very suboptimal for
>>> something like task_struct and any other type that's part of a big
>>> cluster of types.

>> We decided to include the whole types and all direct and indirect
>> types referenced from a structure field for type-based relocations.
>> Our reasoning is that we don't know if the matching algorithm of
>> libbpf could be changed to require more information in the future and
>> type-based relocations are few compared to field based relocations.

> It will depend on application and which type is used in relocation.
> task_struct reaches tons of types and will add a very noticeable size
> to minimized BTF, for no good reason, IMO. If we discover that we do
> need those types, we'll update bpftool to generate more.

Just to see if I understood this part correctly. IIRC, we started type
based relocations support in btfgen because of this particular case:

	union kernfs_node_id {
	    struct {
	        u32 ino;
	        u32 generation;
	    };
	    u64 id;
	};

	struct kernfs_node___older_v55 {
	    const char *name;
	    union kernfs_node_id id;
	};

	struct kernfs_node___rh8 {
	    const char *name;
	    union {
	        u64 id;
	        struct {
	            union kernfs_node_id id;
	        } rh_kabi_hidden_172;
	        union { };
	    };
	};

So we have 3 situations:

(struct kernfs_node *)->id as u64

	[29] STRUCT 'kernfs_node' size=128 vlen=1
	        'id' type_id=42 bits_offset=832
	[42] TYPEDEF 'u64' type_id=10

(struct kernfs_node___older_v55 *)->id as u64 (union kernfs_node_id)->id

	[79] STRUCT 'kernfs_node' size=128 vlen=1
	        'id' type_id=69 bits_offset=832
	[69] UNION 'kernfs_node_id' size=8 vlen=2
	        '(anon)' type_id=132 bits_offset=0
	        'id' type_id=40 bits_offset=0
	[40] TYPEDEF 'u64' type_id=12

(struct kernfs_node___rh8 *)->id = (anon union)->id

	[56] STRUCT 'kernfs_node' size=128 vlen=1
	        '(anon)' type_id=24 bits_offset=832
	[24] UNION '(anon)' size=8 vlen=1
	        'id' type_id=40 bits_offset=0
	[40] TYPEDEF 'u64' type_id=11

We're finding needed BTF types, that should be added to generated BTF,
based on fields/members of CORE relo info. How we would know we had to
add the anon union of the last case if it does not exist in the local
BTF ? What is your suggestion ?

Thanks!

-rafaeldtinoco
