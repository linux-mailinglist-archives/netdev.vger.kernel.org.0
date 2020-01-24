Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F2414900A
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387419AbgAXVSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:18:35 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35901 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgAXVSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:18:34 -0500
Received: by mail-ed1-f65.google.com with SMTP id j17so4085420edp.3
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 13:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdlPbcTG1gi4bBmgvypAeIXkpEGhZuEZxIu3bzVtTxA=;
        b=pnJ6KK3WJ0v+7Jsf9bBB3oGJWFMOyWItMdpiDrJs6tDgKYYe5bTq5NWtrM7cKuleoS
         98yAPBIwwS1OhS/sETjiM3uOv4yfPtldcOz3Up6OEG+rN1gN5nLkdb847QVwv3auVW/T
         LSvGzgx8CvIofFhrFOMMEZqWQTDw2x0W6vuBTMAVPNY91HjPdktYeudzABYzlfkhQ5zf
         w8w4wvmocoau2Bw6WC1o3eoU7CFBIS0XVZHIyOJZiic2Q90koJZiJVgxjg5d7bdRzLoD
         B5IugQZRpn6hvlB5NXnySJVAqDwiny0WoDmfUOvtsobzF1NfHv6zBdODoHi6XsuI+1Oq
         yGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdlPbcTG1gi4bBmgvypAeIXkpEGhZuEZxIu3bzVtTxA=;
        b=Qb6mLoG295NbJNdTlOsbSD1bWyb8WVvC1SKNGSfjyLu0dX2BBChivOUrkuV0T1HLN5
         Pcov8dhGd5DSbew2HM+YTgvRAa8kjPGi1dIh+Li6GlemviFz8RSwGu7psQ8Egr7Aq7Mi
         b6euMtmlmXUsapIUbTRTlKk8Pm7Hf4AonCeX6D4NpIk9kz7ccCKl0aCtRIZq4jBrFKrq
         uY+zxTHhZz4DEyIIzL10/ZPOg1UcDLx0YYvSFCfIkEzK8H8a9G0b/Fk+2GB567PeYA6z
         pO7/gCxOwDpwW1E14SWjb0LisQ1mMIAeF/m5vB+IpJAb2R9eyZpjcFjZ80E86uMqvc1X
         JgRQ==
X-Gm-Message-State: APjAAAU9IcN12TCN0lVfDquCe/CWIhlS0bJaqRc6NHZFJ6WMIA2Rx6rU
        awmt8iFP/LTYhnp4KvTMunn+3fV8zW2G1Qc2tyg=
X-Google-Smtp-Source: APXvYqz6yrvMP5K4bSOZ/CUm5vt8dz/4tdn/5TQJdOtNWDoGeB2txv7UxtwUnHF6HaorizWgPGdBfsE2aTx3vBvXZ6U=
X-Received: by 2002:a05:6402:148f:: with SMTP id e15mr4437053edv.254.1579900713076;
 Fri, 24 Jan 2020 13:18:33 -0800 (PST)
MIME-Version: 1.0
References: <20200124082218.2572-1-steffen.klassert@secunet.com> <20200124082218.2572-4-steffen.klassert@secunet.com>
In-Reply-To: <20200124082218.2572-4-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 Jan 2020 16:17:57 -0500
Message-ID: <CAF=yD-KjqKX4TdhecU9h7RUjpGSOSZcyowE6=2RgWjbdh1m3Gg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: Support GRO/GSO fraglist chaining.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 3:23 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch adds the core functions to chain/unchain
> GSO skbs at the frag_list pointer. This also adds
> a new GSO type SKB_GSO_FRAGLIST and a is_flist
> flag to napi_gro_cb which indicates that this
> flow will be GROed by fraglist chaining.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
