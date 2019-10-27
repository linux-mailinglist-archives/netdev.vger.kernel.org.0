Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED192E6573
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfJ0UzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:55:23 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50095 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727905AbfJ0UzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 16:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572209720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YeHUYCK/IlKxUH3CfOmqQ3rs9pcC2CQcmpmIoy5aShA=;
        b=fRZgDVck0WslEf6hoB/hpt6oQu0UytK3yNHxiP4k0U0P38vfU4HhACNnFXgl3bXFt+CV8o
        xB1c1pt52CCvaLP4GI7WnqnYWaq0ukkys43rPdG3zTr4MQ0MkvFDxjM9ly8pZ9sfxFwlgy
        tZDzObfnM8k6zvn7sqn3QFB3HYcA6Jg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-nrsPyfN7OUGvG2lPkHB6HA-1; Sun, 27 Oct 2019 16:55:18 -0400
Received: by mail-lj1-f197.google.com with SMTP id m7so1519544lje.11
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YeHUYCK/IlKxUH3CfOmqQ3rs9pcC2CQcmpmIoy5aShA=;
        b=IUGACi0zeTCPQ8aU+rnFMOktWwBUh4cONmBSRcr5bDDdUpCJ8wY3y53xbDlzq6gGoY
         pUI81ZQ+06vMMFgycPgf4nXl2o6vW6HNa2yd3Mcq6sSJp6Ib1CSBlzBOVL4nMkTc8lWg
         1Wg5U1P1xwuhVgHfpVwH5yDMB1PBfSKaLGTN9ap9/sDv0BY0mG39d3Y0ylr/mtYpLJfx
         +LWnAZIF9VaqrBcjpzlaIIA7PGxSdMZIkG9loIz4IA6KqmApJtsSR18H3pKoyYs8BMsr
         PJJOgvGqPUPnG/ncY2r7vGylmAlF9A5fSLWiTbCB3bpt6EbUlKmN0Mo/FFla6X3/paO0
         HIow==
X-Gm-Message-State: APjAAAV2y5YKsvHv1Zl49Q7Rfp/4PujuEk5XbvrNT2HZU2Yio+MzTtMk
        8PNsemF99pZ73ibPJEP0XeQFOuDtJ1cohiQ/KD2h+wXWnq1YzXrLsLWKSE1mP69QNWdjLMAsKmx
        zHwkA3Y81DQGfprlY
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr9290429ljj.188.1572209717127;
        Sun, 27 Oct 2019 13:55:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8FZtSydpSq2B0agUrJg7VC+Rb3bBR6I8HYekHP5er16FCw9Rq8EupBGmuyRy55z6PpS6gSw==
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr9290421ljj.188.1572209716984;
        Sun, 27 Oct 2019 13:55:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v10sm2040801lji.46.2019.10.27.13.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 13:55:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 738191818B6; Sun, 27 Oct 2019 21:55:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_set_log_level() function to adjust logging
In-Reply-To: <CAEf4BzYC6U-QC48nRkicb9YHNt+6xPkQAmTZcoEFt+u_vkExYw@mail.gmail.com>
References: <20191024132107.237336-1-toke@redhat.com> <CAEf4BzZAutRXf+W+ExaHjFMtWCfot9HkTWZNGuPckBiXqFcJeQ@mail.gmail.com> <87sgnejvij.fsf@toke.dk> <CAEf4BzYC6U-QC48nRkicb9YHNt+6xPkQAmTZcoEFt+u_vkExYw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 27 Oct 2019 21:55:15 +0100
Message-ID: <87r22xsybw.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: nrsPyfN7OUGvG2lPkHB6HA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sun, Oct 27, 2019 at 4:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Oct 25, 2019 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Currently, the only way to change the logging output of libbpf is to
>> >> override the print function with libbpf_set_print(). This is somewhat
>> >> cumbersome if one just wants to change the logging level (e.g., to en=
able
>> >
>> > No, it's not.
>>
>> Yes, it is :)
>
> As much fun as it is to keep exchanging subjective statements, I won't
> do that.

Heh, yeah. Even though I think the current behaviour is incredibly
annoying, it's also somewhat of a bikeshedding issue, so let's just
agree to disagree on this, drop this patch and move on :)

-Toke

