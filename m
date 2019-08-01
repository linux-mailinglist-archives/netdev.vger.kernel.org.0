Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8457D29F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 03:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfHABLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 21:11:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34837 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfHABLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 21:11:55 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so140632055ioo.2
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 18:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KYjXgzbuA5VPSZKIaaDEIbincCvTUENizjgRBJ7u4z4=;
        b=RgQxS6GBfA4EGZjcP+2D999s7JHocAxj1o95Dt/vl2W/PqeNe8sw92zwrZATiNxzlr
         wQIcRKfMscwRkwj/Ii+Xe8T/Iy4qTV11dmZXRLq4Z4I6bEe2K7i14sg717sCnn2w2Qol
         XYVhMQRR1lxWdRSOsAHKrW7lQkmF05hG6pT1UAEzN5tqAnY4y/EWcX5TGNaAv5Otu7Mh
         OodKsjzc2FmWtg0KjZM9TcEDI0OpNDm+VEvyYCaP9v8bK4ca90562teAN7M+F67gtFzg
         0/zLH/wQypo10GV0PISVqZ6M+Hp3RM0NY3FfCyTk1x4+cAo4uvzYvWHlZEp+p0VCbl5h
         FLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KYjXgzbuA5VPSZKIaaDEIbincCvTUENizjgRBJ7u4z4=;
        b=uEwkblHdFcbql0URmZ87WF94T+Ub3wKNPdxWVcowVVao3LFJJkYnbRY889j2lBV09z
         1FG4wJWIiW32AVabQNID8Mx4Fprw0cqBdXFE1vaTLF5Fgxq/06k9Ksq+b9aD8+TtQ7cP
         0bJ/Dd3adMp/GuZpLY9d/ZAaMPzBuNc5wvM1l9jlAaRMvpVMFs5KT1u9Q1kQjSO7Ve/y
         ygi4mah1oxOseGHQHC4xazxdHUQZBVY857FCR0GJMqytbSOi63PgLdm54LifDkzM+9r3
         s0kfjJnvhMMEZfj6+Vr96VS+SnVTDyvGenXxj59oyD00zpuBu4VG4KWEMHoojI0JSuCC
         RzNw==
X-Gm-Message-State: APjAAAUm7svQtGeUV1XqsCx+FV0qNOUhZ6emASRsrXAsUcsmokCyw/iO
        b4rJMVrbONfdIIwgz+qjRwFUGjJnoK+gGy55QLE=
X-Google-Smtp-Source: APXvYqxFjhzMfSW7riJmYRdYdg1Q5uZNdag8E3JKRzS5+x8s3vPkCONkVvGPtH2nfSyHG1vfGPvqaLb66m7AYJvUU4w=
X-Received: by 2002:a6b:dd17:: with SMTP id f23mr100290864ioc.213.1564621914239;
 Wed, 31 Jul 2019 18:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190801004506.9049-1-stephen@networkplumber.org>
In-Reply-To: <20190801004506.9049-1-stephen@networkplumber.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 31 Jul 2019 18:11:42 -0700
Message-ID: <CAA93jw6aRwUt=r9EAeRmZmJJ=KbDTsdxyb8DQWCX4NWkOUsnbA@mail.gmail.com>
Subject: Re: [RFC iproute2 0/4] Revert tc batchsize feature
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        chrism@mellanox.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Does this fix my longstanding issue with piping commands into it? :P

( https://github.com/tohojo/flent/issues/146 )

On Wed, Jul 31, 2019 at 5:46 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> The batchsize feature of tc might save a few cycles but it
> is a maintaince nightmare, it has uninitialized variables and
> poor error handling.
>
> This patch set reverts back to the original state.
> Please don't resubmit original code. Go back to the drawing
> board and do something generic.  For example, the routing
> daemons have figured out that by using multiple threads and
> turning off the netlink ACK they can update millions of routes
> quickly.
>
> Stephen Hemminger (4):
>   Revert "tc: Remove pointless assignments in batch()"
>   Revert "tc: flush after each command in batch mode"
>   Revert "tc: fix batch force option"
>   Revert "tc: Add batchsize feature for filter and actions"
>
>  tc/m_action.c  |  65 ++++++----------
>  tc/tc.c        | 201 ++++---------------------------------------------
>  tc/tc_common.h |   7 +-
>  tc/tc_filter.c | 129 ++++++++++++-------------------
>  4 files changed, 87 insertions(+), 315 deletions(-)
>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
