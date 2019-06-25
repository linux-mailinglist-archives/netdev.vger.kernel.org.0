Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7024E526A7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfFYIaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:30:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54252 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfFYIaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:30:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so1862709wmj.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5FwrvkEYWMfxgPl/5Bces838lW482p8FQmerxtvFCzk=;
        b=JZiPbs3VS9/MmeQmocbNnwyozfP59iMFsSBz/3erxK8BipCssq0xvAf30H+3RfWJnN
         y8BYAAIheY0Rfz5et8U+EqHC6YQ7BiTUuQZwp1/Vv3jKPoc2likuRMTirWXdKkehEcZg
         /FcwNhR1/elwWzsg31svilSxNFZPX0V7Yfkno4v72JtEA3XqUXTLnTlWz4d3uQyIQe7d
         0nhf7OVVoQBzW1pgCGq/tXXe7Kq7eJU9XmRAsqZWFV0X5yVpsavol8DJ0xptUS1Yu93q
         7t6BCvYrfWxhd+AZjHHy7LXPZI2vSrVnyfMDaUUn8yZwfIwUzKVlexxbjmHnHy9w0zGK
         vnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FwrvkEYWMfxgPl/5Bces838lW482p8FQmerxtvFCzk=;
        b=oXGeKAt3CpijIdcOO9S9hU30VgRakvljv5HbF9UsxhmixMRNxjMdrLfh9rBgGRzrbh
         gVAl7v3EFLgGzQ2J2FYF4AjIfGI48qP4a5Kqh1hHmEUWr5cyNkcq0Xgn4sIs84nsvb6Y
         +M1hTXGaoIUJWDS1mdhF6uG/zQBgOy+gqz+rD0TJqVkCeU4kLZlLamj1brvH6Hfz7Luy
         6Ub4gH3Lr1wPunpHS5jpnohJAJCI1DOC9h8ejVYdHH6lkFtt4yUAGVZos9ES6FLx8loO
         B4kJZBzrSTT7eXM4T0TJ78aE6ua/81N5ZJr388+H1Yey4ELos0mtGuzS+NrgIT2wbddt
         CwdQ==
X-Gm-Message-State: APjAAAVa9utaw9MV50mL2ISWTiWqR/8VOzLJf5F+3RR3P8A0TVsjapm7
        ShrAK/sjVGwS1/KjNTZDToE=
X-Google-Smtp-Source: APXvYqxX/PgKMn1oRr2GsnorcTcNuIwQ5wmJaD8yKQxK+Dwvjg58zTsC59o/Aj4hbfvlazpOGbsAEg==
X-Received: by 2002:a1c:5f87:: with SMTP id t129mr20207685wmb.150.1561451417875;
        Tue, 25 Jun 2019 01:30:17 -0700 (PDT)
Received: from jimi (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id o12sm13873189wrx.63.2019.06.25.01.30.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:30:17 -0700 (PDT)
Date:   Tue, 25 Jun 2019 11:30:10 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, fw@strlen.de,
        jhs@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        shmulik@metanetworks.com
Subject: Re: [PATCH net-next 2/2] net: sched: protect against stack overflow
 in TC act_mirred
Message-ID: <20190625113010.7da5dbcb@jimi>
In-Reply-To: <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
        <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Mon, 24 Jun 2019 23:13:36 +0100
John Hurley <john.hurley@netronome.com> wrote:

> TC hooks allow the application of filters and actions to packets at
> both ingress and egress of the network stack. It is possible, with
> poor configuration, that this can produce loops whereby an ingress
> hook calls a mirred egress action that has an egress hook that
> redirects back to the first ingress etc. The TC core classifier
> protects against loops when doing reclassifies but there is no
> protection against a packet looping between multiple hooks and
> recursively calling act_mirred. This can lead to stack overflow
> panics.
> 
> Add a per CPU counter to act_mirred that is incremented for each
> recursive call of the action function when processing a packet. If a
> limit is passed then the packet is dropped and CPU counter reset.
> 
> Note that this patch does not protect against loops in TC datapaths.
> Its aim is to prevent stack overflow kernel panics that can be a
> consequence of such loops.
> 
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  net/sched/act_mirred.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 8c1d736..c3fce36 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -27,6 +27,9 @@
>  static LIST_HEAD(mirred_list);
>  static DEFINE_SPINLOCK(mirred_list_lock);
>  
> +#define MIRRED_RECURSION_LIMIT    4

Could you increase the limit to maybe 6 or 8? I am aware of cases where
mirred ingress is used for cascading several layers of logical network
interfaces and 4 seems a little limiting.

Thanks,
Eyal.
