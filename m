Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E75456F4A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 14:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhKSNGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 08:06:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235264AbhKSNGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 08:06:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637327023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hKfzGk0Wpd8IGC/prDVcUoPiImNh9tLcC0HmBj731Mc=;
        b=Et00upzkQXNMker+kjWY0O0Mj9076EBNzuiu8jqr8FTtYGa2Trfaz/n1gix5MRypsZyg7X
        3g+Z+YZMUQeGbwFMyYTW1ciNIfQSbHRq0SZn/m3LCsimHQrI1O6PqG9n/8eTVA8kRN1piA
        1RGpO06lZCNFzPYHR/NXu9XkfceiaoA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-lEg5xjHzNYuhXxhQQhIt7Q-1; Fri, 19 Nov 2021 08:03:42 -0500
X-MC-Unique: lEg5xjHzNYuhXxhQQhIt7Q-1
Received: by mail-ed1-f71.google.com with SMTP id c1-20020aa7c741000000b003e7bf1da4bcso8292892eds.21
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 05:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hKfzGk0Wpd8IGC/prDVcUoPiImNh9tLcC0HmBj731Mc=;
        b=Wf6tiWvQPI/txyqoMiu0oL03TlRZmgRztTYiHTeFtB2gmq92INak4rss5XwVCcvJtb
         x7Kg5ahysGd1ceIvtoaKdNv5PFX2+B6blzbzseNttD0PmhSR9aMxZ9ruNQKuqtX63i4C
         Dx/QDP/AYXKpmQLY6ao8l43VM50HccsXF2XVLl1d9A+RNpHiszMVjnkPFIo6lclh0iNj
         GVNlYEq9QnLUFQ+z+WOez7zOTH0z145lHoGM2+orP4o2pkrzL5xgvQ2mMP6japxKnaL+
         EMMVaTwo49qu9BkCoA3f+0weobJHz8k8IpcHBD/Lv42/7NeFlhoU0uIs0IVodHRbzIKu
         8N7A==
X-Gm-Message-State: AOAM5332uPWKpaEMis+H/ZC0+8nDUP4C0WAQdjs1V4Ycmut2vradz8xh
        KN23ECecioDCfrBkqwxqpus5KOOZWGglfFkSCq6DrmAzdyJa8wHqaRge8YCsYTs2df0+1JissfP
        8lzSm1Yfbedds7ynM
X-Received: by 2002:a05:6402:34d6:: with SMTP id w22mr24389964edc.35.1637327019607;
        Fri, 19 Nov 2021 05:03:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0iYtHfCnciVMnXitwgUqkXXZdqqWWg/E2uIeEkNqY5pWCuyejuk1lAeev+8CNOUCiai6nhA==
X-Received: by 2002:a05:6402:34d6:: with SMTP id w22mr24389826edc.35.1637327018826;
        Fri, 19 Nov 2021 05:03:38 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id dz18sm238310edb.74.2021.11.19.05.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 05:03:38 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 87A81180270; Fri, 19 Nov 2021 14:03:37 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 2/2] bpf, doc: split general purpose eBPF documentation
 out of filter.rst
In-Reply-To: <20211119061642.GB15129@lst.de>
References: <20211115130715.121395-1-hch@lst.de>
 <20211115130715.121395-3-hch@lst.de>
 <20211118005613.g4sqaq2ucgykqk2m@ast-mbp> <20211119061642.GB15129@lst.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 19 Nov 2021 14:03:37 +0100
Message-ID: <877dd4e1qu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

>> In terms of followups and cleanup... please share what you have in mind.
>
> The prime issue I'd like to look in is to replace all the references
> to classic BPF and instead make the document standadlone.

Yes, please, this would be awesome! :)

-Toke

