Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A952CD4C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfE1RMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:12:03 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:45417 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfE1RMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:12:03 -0400
Received: by mail-ed1-f47.google.com with SMTP id g57so18002494edc.12;
        Tue, 28 May 2019 10:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lYImdE1K3cUe2xPFfKctCk0xbs1kFjS1GtFoys4OKEc=;
        b=elCiHPbeF+3BBhnD/fPMTklieZ6tyszuUka6t0KBE7hW2jdKkIboHAtr25j9U95Ikf
         SR3t7R2wiTTMWcxf6u57nFDB1rYVtF62i57wVAJy1V+qT3ODXA7vw+48/1p9QfEAw9vY
         DJl0xtovDV+V4awLz00+qFO1WJDc8lLT7dkPYd6XqRr70FHdTOUG/5hF9qC4mmAkntHu
         bcyEqiiMQXF9pVYSYJrJI3prNpAgmZBe15Z9fNX+yf9F644uNPXzhU1sSOshy8aDUp/W
         feiD9ySMIUcHhvNQ6Kb7ctoHYRqqebGN6QPFHqzlxm6aBLO3Y6Wx0OygowJJiPaIpyaQ
         +aAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lYImdE1K3cUe2xPFfKctCk0xbs1kFjS1GtFoys4OKEc=;
        b=gkjukjqnUTTW2RRr6sLqd7HEDChRs8F98gW7M4X9Q3p93CzPU9Vio4U9aEeP4j3mpN
         2WKiLbyMPdNKnO/6VFgLZbP6TA6XyQ7bC5/9235SgJcG1GD5ZK8kiJAcn9TMeJAAI3N2
         rrIQ83g0WBx7JErCFY0JATzSvqqqwQktboSjZSE/J86urFE7C9jQ19TKIXZgSQpinqSl
         yqj8P3seFh5mzGnJkDs/JoRG9FiI5wADeBHJIjywPmrXvqmL1MFxY1EYrcNlxz4UwH3s
         AuFUlsdXN9j5KG11T3ZbbbGHhSpQ10Pqm0W2eFGshSaDFSD1IIrjbb3rpaAiiDPWsRNQ
         llpg==
X-Gm-Message-State: APjAAAXl7Ynb9TsUtGqrCzBHaWN+Tp+3Mx53A12D/VcQ1rRJ/IlWtk2Z
        ntkVoLRLVwXZzbugpSwbXQgWIf0ja37i1cyKBZA=
X-Google-Smtp-Source: APXvYqyAvOfbFAAK6aMyy93n7UREJlpiHInet91UkneecigYVrJX7593QPls/vDRXj8AibJ87Uas7h5rWHEPU6WqUys=
X-Received: by 2002:a17:906:76c8:: with SMTP id q8mr70324783ejn.229.1559063521332;
 Tue, 28 May 2019 10:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com>
 <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com> <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
 <5BB184F2-6C20-416B-B2AF-A678400CFE3E@appneta.com> <CAF=yD-+6CRyqL6Fq5y2zpw5nnDitYC7G1c2JAVHZTjyw68DYJg@mail.gmail.com>
 <903DEC70-845B-4C4B-911D-2F203C191C27@appneta.com> <CAF=yD-Le0XKCfyDBvHmBRVqkwn1D6ZoG=12gss5T62VcN5+1_w@mail.gmail.com>
 <9811659B-6D5A-4C4F-9CF8-735E9CA6DE4E@appneta.com> <CAF=yD-KcX-zCgZFVVVMU7JFy+gJwRpUoViA_mWdM4QtHNr685g@mail.gmail.com>
In-Reply-To: <CAF=yD-KcX-zCgZFVVVMU7JFy+gJwRpUoViA_mWdM4QtHNr685g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 13:11:24 -0400
Message-ID: <CAF=yD-J2eNn4xNu37ekXfDGMtzQjOPVrWJ+EaLqdJmFcrnk8pA@mail.gmail.com>
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > Now that I know the issue is only in TCP, I can speculate that all bytes are
> > being reported, but done with fewer messages. It may warrant some
> > investigation in case there is some kind of bug.
>
> This would definitely still be a bug and should not happen. We have
> quite a bit of experience with TCP zerocopy and I have not run into
> this in practice, so I do think that it is somehow a test artifact.

To be clear, I'm not saying that it is an artifact of your extensions.
It's quite likely that the zerocopy benchmark was a bit flaky in that
regard all along. No need to spend further time on that for this
patchset.
