Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A049140EF1
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 17:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgAQQ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 11:26:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726559AbgAQQ0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 11:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579278406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syBkcXROwOnY6YoIKqq/kOHyBX6ncBqmaYVSMKAbc8A=;
        b=R1inJv9I1VoHeZNT3ZeV5ET1M2doahSh7CxPm8hSqPm30QwCaoZT+jdf1PYk01U0kLMd1P
        uSQ1my1fzX3pO6J568TNcByxB08BfCyzAEifVnDGIex3FUbYAbLn0UVCxk+C56L06xtYbG
        Gh4uWD9656VA7hvfQyT9hFNQFY7wfs4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-Iu0h2AxvMvycjgEOI_Nkiw-1; Fri, 17 Jan 2020 11:26:43 -0500
X-MC-Unique: Iu0h2AxvMvycjgEOI_Nkiw-1
Received: by mail-lf1-f69.google.com with SMTP id a11so4506302lff.12
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 08:26:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=syBkcXROwOnY6YoIKqq/kOHyBX6ncBqmaYVSMKAbc8A=;
        b=oQnQkIPe0T9groEjRRut2a1Q8QLeo/iwrdp4J9WiNiYg2cniKXjSWxY1eWDAo5U4z1
         3W0lYvC11tJP1kmPPceS68FjfOHg9fC2ah7tUfylWJwkP9y574+YopdSwwTsqjJoztj0
         7tD52C2Vp1Fvmp62EWhq3TAnWlpL1zldi0MFouAPU2T4yAUQq5/YTTNWWNCDRY3zzwMo
         oH1CX6WMmxwOm3qm/B4V5rZXapJGtsbcyxc86kyEHt8YA9El38pR8uFvpQfAJV2Mc/jp
         qu1QMY2+Jrc5cFY0UT5dVI8d0LdsTFcGxuyay8/e/oIxT/ltXP+GiN6rdZEw3B8VoWAy
         oy9Q==
X-Gm-Message-State: APjAAAXmR3NiRJ4NWQqE09YJ/ugTU8oCVwqrAxYcaG5Iw3wLlib4G6iM
        TvlxXqN2W83RPkrDHNUPVyGoerA3RZsuQPTwf209SBQlf0oQnyikt43D08e6yUJwSiXlXfeNX31
        dBKrhIk1YtEcDo/9x
X-Received: by 2002:a19:c648:: with SMTP id w69mr5769098lff.44.1579278401994;
        Fri, 17 Jan 2020 08:26:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9ob94zqeN2D5WcW+oWhxpC90VPJPBNOMMuQiWTwpFkQ64iHIgmP9Pp2TLTHTmthK/3vZBqQ==
X-Received: by 2002:a19:c648:: with SMTP id w69mr5769083lff.44.1579278401717;
        Fri, 17 Jan 2020 08:26:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o19sm15137568lji.54.2020.01.17.08.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 08:26:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4A97F1804D6; Fri, 17 Jan 2020 17:26:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
In-Reply-To: <20200117103957.GV795@breakpoint.cc>
References: <20200116145522.28803-1-fw@strlen.de> <87eevzsa2m.fsf@toke.dk> <20200116160435.GT795@breakpoint.cc> <8736cfs73w.fsf@toke.dk> <20200117103957.GV795@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Jan 2020 17:26:40 +0100
Message-ID: <87sgkeoxq7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> And that the crashes at least shine a light on
>> them forcing people to consider whether that is indeed the case?
>>
>> (IDK if that's actually the case, I'm asking :))
>
> All I was saying is that if the getters were more tolerant a few crash
> bugs could have been avoided.

Sure, and all I'm saying is that that is fine, as long as it doesn't
just turn an obvious crash into a not-so-obvious behavioural bug :)

-Toke

