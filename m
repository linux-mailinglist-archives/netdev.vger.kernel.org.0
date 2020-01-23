Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7018146945
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgAWNiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:38:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726811AbgAWNiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579786696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h6uD+1e68gi91qvBrZ/lqf2TnuTpmHDoEyL/oCZyo6k=;
        b=b+rpdp29lwZB58ZRemVOZMHijjNH1pUPuBEnq1JUA+xt/XFGutQAACZv2JkETUJ78YErEX
        xiklm7JejnYKdOe87SfXLP8a30p8CoVFs5FUwmlhH+X0f2ZmZu2oX2IM8PBwFwu+Jy4kcH
        N3WJxSfMgVAbH7YHzt4/Q3+oH85qLXQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-ZkYRf82TMOO6neHWmu6-7g-1; Thu, 23 Jan 2020 08:38:14 -0500
X-MC-Unique: ZkYRf82TMOO6neHWmu6-7g-1
Received: by mail-lj1-f197.google.com with SMTP id k21so1093962ljg.3
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 05:38:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=h6uD+1e68gi91qvBrZ/lqf2TnuTpmHDoEyL/oCZyo6k=;
        b=cchE71T8rD9tRdPHDc6/hUx7Nx6Vq/zF3gS1Hq9M5JthFOQQCZnd40v8kamZo15FrM
         5gI50SCU8GqoFkCM5W83SAYxR0B6ThW1QsPdrbEL83aAdBtrH6W4uJKcYsFLCxEAkNZY
         D7OnUdzc+5vyIOWZm22l+Wky3W2YSCdDiEQ8T6TKPvgEnnbnYeFE0kXPpVK3i+MbNytk
         7u0zL1eSDot8pexH/VPEty3mjoJ14e/fY9q/EH/S8Wo0wQZaWWQ82MD3oxTOhvKN4Q6J
         E06yViqDgptOLfCFICTFc8iKhF56/vVHlqPi2dt/2ocEqDQNRogPiqQ29yuFnbaMSuAe
         Ezlg==
X-Gm-Message-State: APjAAAXThXv0JUXz/2xI8kDqixJTEGQioh+rZFEdRnKt4f2t+7TSSqPa
        mEbo58IfUMrVcHd/Mb5F5icU1+Vo8uDdlfIrUo21X68KRGFzJk35nu1IufDIDJY6iAT28ebr3MP
        Frt+OE23KnasX7rmo
X-Received: by 2002:ac2:50da:: with SMTP id h26mr4787295lfm.80.1579786692705;
        Thu, 23 Jan 2020 05:38:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4BWaWs+3H0Frdse6iV+jJqbBxUwLv0Dvg8acnZgByftBSE4MEGvlY+Jnho0dUBWe823FHAw==
X-Received: by 2002:ac2:50da:: with SMTP id h26mr4787274lfm.80.1579786692511;
        Thu, 23 Jan 2020 05:38:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s4sm1309808ljd.94.2020.01.23.05.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:38:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F36231800FF; Thu, 23 Jan 2020 14:38:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Amol Grover <frextrite@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: Re: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
In-Reply-To: <20200123120437.26506-1-frextrite@gmail.com>
References: <20200123120437.26506-1-frextrite@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 14:38:10 +0100
Message-ID: <87d0ba9ttp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amol Grover <frextrite@gmail.com> writes:

> head is traversed using hlist_for_each_entry_rcu outside an
> RCU read-side critical section but under the protection
> of dtab->index_lock.
>
> Hence, add corresponding lockdep expression to silence false-positive
> lockdep warnings, and harden RCU lists.
>
> Signed-off-by: Amol Grover <frextrite@gmail.com>

Could you please add an appropriate Fixes: tag?

Otherwise:
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

