Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFDE2CEB15
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgLDJji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:39:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727518AbgLDJjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:39:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607074691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=apkPa8AtY5qI+Lx8h0RIJ14ymUykNA2gmtc5uu7K+b4=;
        b=FyMXGW6RPqesspba/Wtp9P1N3nXp00QmXS5Xwlr8bBU9zVFXEzJeRDoz1zVvJTWUqEw6fB
        8UTd3CXsiapozYDd3ch7IWWVIg/Xc04LjvyjZZGat+v/JgjWMmL/6VdsLJnOa/yEFGJGtB
        0CvlKVB8aa4Qw+DV9vVGthJKzZ+Drv4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-L8VQzb7JOmaDlljRA6awmA-1; Fri, 04 Dec 2020 04:38:09 -0500
X-MC-Unique: L8VQzb7JOmaDlljRA6awmA-1
Received: by mail-ej1-f69.google.com with SMTP id z10so1863061eje.5
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 01:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=apkPa8AtY5qI+Lx8h0RIJ14ymUykNA2gmtc5uu7K+b4=;
        b=Y889jaJYLgNcJcgruHPezvziGktrnChIaRQIkgiknna3Q9vlePj9z5mB5j/Vf39dDN
         FKW/YYXxFTdNSCRU28C2ReFeRnpWoiC6irr1U0EwniWCoSz9twn186Tl43ip3kQ6/Go2
         LsuY+F4dH40vWMQuAaPC+qanstPaMLapsU0Am25f8Ei3ts5R2xx+6G08QN3n6+0Pq7Vk
         BH7RQgTyeac5aPCsMXsE4WtgoxJd8Xs0sSwfUujD+9vfL21N9ftx9hs3TsbJcTXGq606
         MkR+1uA86dSRGg04kUuhaPf60/iE2dqyool8am7jUC1Xye1pmPxNFoiTekd4H8R91XDg
         JWHw==
X-Gm-Message-State: AOAM531qtfJC2x04Bln1G+udKxrtAb/OPiI5vuzR/4oYVM5wFUUB4nb/
        HiKRHKD9UFSwYQ+a6xHpFiLU9wJbQWLXyYK3a7kyuyaxtjh8siTCR6NRn72Kp8DvtMgVKMNQZEA
        qxwVoQGqQXwQzjEKI
X-Received: by 2002:a50:d011:: with SMTP id j17mr6689742edf.123.1607074687976;
        Fri, 04 Dec 2020 01:38:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNxFWO6FFyJVolGD9Pye9fYp5KlEmHb8yz/DhNIY2dFq2yCkMGo0POHRcDRXgqhAgUGBKsqg==
X-Received: by 2002:a50:d011:: with SMTP id j17mr6689728edf.123.1607074687761;
        Fri, 04 Dec 2020 01:38:07 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t26sm2692268eji.22.2020.12.04.01.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 01:38:07 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B6322182EEA; Fri,  4 Dec 2020 10:38:06 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf 1/7] xdp: remove the xdp_attachment_flags_ok() callback
In-Reply-To: <20201203174217.7717ea84@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <160703131710.162669.9632344967082582016.stgit@toke.dk>
 <160703131819.162669.2776807312730670823.stgit@toke.dk>
 <20201203174217.7717ea84@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Dec 2020 10:38:06 +0100
Message-ID: <87o8j99aip.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 03 Dec 2020 22:35:18 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Since we offloaded and non-offloaded programs can co-exist there doesn't
>> really seem to be any reason for the check anyway, and it's only used in
>> three drivers so let's just get rid of the callback entirely.
>
> I don't remember exactly now, but I think the concern was that using=20
> the unspecified mode is pretty ambiguous when interface has multiple
> programs attached.

Right. I did scratch my head a bit for why the check was there in the
first place, but that makes sense, actually :)

So how about we disallow unload without specifying a mode, but only if
more than one program is loaded? Since the core code tracks all the
programs now, this could just be enforced there and we would avoid all
the weird interactions with the drivers trying to enforce it...

-Toke

