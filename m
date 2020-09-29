Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B6427CE0E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgI2MuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:50:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgI2MuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:50:10 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601383809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mM7JGFZ14VdMV+ifvneOX/UKONF5CIbp3sZz7ji4/m0=;
        b=FGpkiHj6Ys5OMuqmCJCNZQhHxcVzNVwC0Sk71Y9si6HTVV6YpAgHk7YfnmmnlzqvHmfg5G
        mRwhzm1UjCrENuIGR6gVz56ZXbrkQRK9/UvQCZtr2mXK4fZEtKYcviJHbxr/mtPpabaiAl
        YY+fGRNYYNzZXsZSDrgC0vZrsjiwYvM=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-gQDqgCjBMOGv5NLdCEuxDA-1; Tue, 29 Sep 2020 08:50:05 -0400
X-MC-Unique: gQDqgCjBMOGv5NLdCEuxDA-1
Received: by mail-oi1-f199.google.com with SMTP id m5so1566446oib.19
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=mM7JGFZ14VdMV+ifvneOX/UKONF5CIbp3sZz7ji4/m0=;
        b=nTzRyVnNMg6ZClRM5QPseeaRezBkSaheqXac+u+qIuN38bE8+OCx3bqc/6ALar30Bc
         qiWz0yopRr0li2IzHgJHXlipzG/+Pb+tEjvCwM5dFSxgN3JuTdWcke2skt1lXDlUdsVJ
         c/7tJQD4JlvUUE/u8HweA+0gAa0mUniAGbFWYHWMvk62o8DU0kG5qhxFsRVBSTy1m346
         Bal8elWdbiMVTolJhQdgmkPpePhdXu5p+VdvSxhsRrAi5s8KplzHbgbgfhN3lvem/H9Z
         8L38R+VOP7qlUMD+r9TC65I5jMSB4RChFQZWnKUmJq5lW2p+Oc9gxs5kY8q0ZgikPQrh
         /FpA==
X-Gm-Message-State: AOAM530g92VzcupmFgEppOuXlu2s7ZIQrQ0SfX6cd2wKNbyY3IdhWbT5
        NfiL2ZCmW/0Wlpbwl7YD3e/4H7Yo+pCzPCABKhQhrYTEyI6kLllOY3Sq2p5trfNVDvy0vaOxyMT
        p+gc70ePlAORlhYSu
X-Received: by 2002:a9d:6c4d:: with SMTP id g13mr2500825otq.367.1601383804698;
        Tue, 29 Sep 2020 05:50:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4Yi/xiyKzsAjwnkcMnL9GPFexMht69FB/IkIio1Gj1RE3uQyyPgACZ0MZq1tCC4E7GaO1gA==
X-Received: by 2002:a9d:6c4d:: with SMTP id g13mr2500801otq.367.1601383804352;
        Tue, 29 Sep 2020 05:50:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id j26sm2841526oor.21.2020.09.29.05.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:50:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 27577183C5D; Tue, 29 Sep 2020 14:50:02 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf-next] selftests/bpf_iter: don't fail test due to
 missing __builtin_btf_type_id
In-Reply-To: <alpine.LRH.2.21.2009291333310.26076@localhost>
References: <20200929123004.46694-1-toke@redhat.com>
 <alpine.LRH.2.21.2009291333310.26076@localhost>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 29 Sep 2020 14:50:02 +0200
Message-ID: <87zh5821dx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Maguire <alan.maguire@oracle.com> writes:

> On Tue, 29 Sep 2020, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> The new test for task iteration in bpf_iter checks (in do_btf_read()) if=
 it
>> should be skipped due to missing __builtin_btf_type_id. However, this
>> 'skip' verdict is not propagated to the caller, so the parent test will
>> still fail. Fix this by also skipping the rest of the parent test if the
>> skip condition was reached.
>>=20
>> Fixes: b72091bd4ee4 ("selftests/bpf: Add test for bpf_seq_printf_btf hel=
per")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
>
> Thanks for fixing this Toke!

You're welcome! :)

-Toke

