Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E61149641
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgAYPcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:32:10 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:45937 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:32:09 -0500
Received: by mail-yb1-f196.google.com with SMTP id x191so2570553ybg.12
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 07:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TLq8UDbxMEE8RRJdMMvTPMWtHGTGNL35MimJPdhKTys=;
        b=M6fXGAhRLDFfdNKLV3+OVlnYhOfXE91QnMbIiFQ+S38dQ5t+W8xQftAomIuzNPlNNR
         e/M43385UxE5qHfrOmATWfKun7GjsQKTidlQ8TtIIldEe1cAQ/YPlm/DKZbM99h4heUi
         45XKPdX1uoYgFR5sCcDAvv1ghIXJ/S31ALMFezFBzOrwWRpXRuHTTh3uTWf1FSKZlbfu
         0N5doeErXQpqGKdOA/2jVIhAkNIT0JgjyYBBCuOcGmE47ogjHGbTZKW+JpQKynHTUOEM
         FZch8fsQwSHeXbTK24WO4lYvkEE3Zrx9NQHAsvp3sVufJM3ZstE/2Au7zUK+Wfw3CC/2
         gcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TLq8UDbxMEE8RRJdMMvTPMWtHGTGNL35MimJPdhKTys=;
        b=pCR+zmv22kdDEtRvRrF1BvQQ3pFtfE1F3cUcR/Op8aFnEt44KNQeSiyW/VGKqcOK6e
         rHQxRtRGhTUIGrdAaxiI2vRBAUbC4JucH8c8vq/ZtpbA7osaNE5nHoOsbVCCV93tGbof
         fimPm9y8dL/kVb9pdhFPO4vYPWPOqtMXAgf7C84XxDzo0xN+Vp+7rq5kfpQHX9aed0Tu
         IhcoPMKiE5NxBB0+kWQgpPHvBu0BdzVxxoLpW3LBHV/b82FNZJhEm2/1gzrYOtYTqclH
         F47PG06vcTHsd9TVPkD18RQS3j/MaZsveMY13/16B1UUzXzDhED1+OR45IKTXX0lstc0
         1wAA==
X-Gm-Message-State: APjAAAUDkJ51ca0SCJyWBNY9aUadz0dpNdWJwViscG8eXyBMjlTLykse
        v548idVzBGvHZeVub2RhrYul1JOa
X-Google-Smtp-Source: APXvYqzOrY2KORcqBJ2DdT4MQUVQN72fmvanH78rw5BVh8PIeS/oCl+kDty159lKVFPHwy+3zZzO/w==
X-Received: by 2002:a25:cf0b:: with SMTP id f11mr6829718ybg.469.1579966328411;
        Sat, 25 Jan 2020 07:32:08 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id w5sm4135522yww.106.2020.01.25.07.32.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 07:32:07 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id w9so2600716ybs.3
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 07:32:07 -0800 (PST)
X-Received: by 2002:a25:ced4:: with SMTP id x203mr6504376ybe.419.1579966326770;
 Sat, 25 Jan 2020 07:32:06 -0800 (PST)
MIME-Version: 1.0
References: <20200125102645.4782-1-steffen.klassert@secunet.com> <20200125102645.4782-5-steffen.klassert@secunet.com>
In-Reply-To: <20200125102645.4782-5-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 25 Jan 2020 10:31:30 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdQWBbyMyPd27oMHG8sL5F+A6tqReN30JiNNQMYXjeSnw@mail.gmail.com>
Message-ID: <CA+FuTSdQWBbyMyPd27oMHG8sL5F+A6tqReN30JiNNQMYXjeSnw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] udp: Support UDP fraglist GRO/GSO.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 5:26 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch extends UDP GRO to support fraglist GRO/GSO
> by using the previously introduced infrastructure.
> If the feature is enabled, all UDP packets are going to
> fraglist GRO (local input and forward).
>
> After validating the csum,  we mark ip_summed as
> CHECKSUM_UNNECESSARY for fraglist GRO packets to
> make sure that the csum is not touched.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
