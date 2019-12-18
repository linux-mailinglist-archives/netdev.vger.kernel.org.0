Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF6A124C58
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfLRQCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:02:40 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36829 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfLRQCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:02:40 -0500
Received: by mail-yw1-f67.google.com with SMTP id n184so959526ywc.3
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UNHto7c19KYkNrr+s3no7Fvzt7np2PQu3GR/mSDcwTQ=;
        b=mdxbgt+8n8dcqpSevfMQN/wuTE/+kr0KNE6fnRupFtjnVjyrdPcEsoUMxtBKGDB35N
         G8R3zkgjWfmMIMK7hy/daYGTs3aePH6rLoSl24y9S2/8922/p/8YPhC9kHSP0tdSroLe
         8iAtyXvjfSuDABC/TynGHYkDWeXaAIe82Xl/B5txDg73akTYCJHe7/O2GLUWErcxa+8r
         jdSheCJMGZcq5ned5qUjGM5mmn0Qtdjo8aeT8Cq+OZb/C+w/xOh67ssiX2P6gLqZ6PaG
         w5D2+CGcwZ7llzw4YrlaFw6JhgXFObjpLb6WxhKW8CoFEGhxcOntvMP6kUNbpg6gerf7
         YCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UNHto7c19KYkNrr+s3no7Fvzt7np2PQu3GR/mSDcwTQ=;
        b=c+3OVMi/9rTVI5bFA7Y7VDPyhFWU6oQc2KAvgmVGxvmqBJYlSCgQ2MzKm3WskpZfgx
         sgoYZmXuXPHTENESNzSwWZdj10U9bXuXf2aZujMsUmtK8q3pjPz/zcjOxi+QnD+gAuW0
         wbd8FDgB1fdPHwCGeXaJmrCwrcB3inVxERMhIOFU5xuCXfuGb8o2ldpTXVQiXwNnq7CF
         HAzcmU4tc/7g+vWoQxvxLKmyHfDunOaHq/BD3ia6AinodcwDDsdUH0A05wazKWodISgs
         v5Qwy5PrZ8ECj6Go1mNhKLrSqA9NndO+tTYn52KzF5aiRqSmJjsH6DcM2Bi32og8PCtq
         FgmA==
X-Gm-Message-State: APjAAAWXtohRQDZhLcE8IbfMnb1EmOL6PY34VTLzsmYi9st4aToMVxDA
        5jUhzROxrwvg0YcBPuV5Pf9V8hUK
X-Google-Smtp-Source: APXvYqw5jtTgWol5C4CbDgn492JMcdE8hvR4eV7ZMwlL8v4+nXNOl9tO+KNAYFk3Aw7vCka0FXIZDQ==
X-Received: by 2002:a81:a314:: with SMTP id a20mr2659540ywh.130.1576684958974;
        Wed, 18 Dec 2019 08:02:38 -0800 (PST)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id h184sm1080664ywa.70.2019.12.18.08.02.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:02:38 -0800 (PST)
Received: by mail-yw1-f54.google.com with SMTP id i126so952175ywe.7
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:02:37 -0800 (PST)
X-Received: by 2002:a0d:dcc7:: with SMTP id f190mr2729451ywe.193.1576684957253;
 Wed, 18 Dec 2019 08:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com> <20191218133458.14533-2-steffen.klassert@secunet.com>
In-Reply-To: <20191218133458.14533-2-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Dec 2019 11:02:00 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeT_8yT9w_5J9s=bg9pCNkOdHBgAnU5diXds+zY5EkygQ@mail.gmail.com>
Message-ID: <CA+FuTSeT_8yT9w_5J9s=bg9pCNkOdHBgAnU5diXds+zY5EkygQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: Add fraglist GRO/GSO feature flags
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

On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This adds new Fraglist GRO/GSO feature flags. They will be used
> to configure fraglist GRO/GSO what will be implemented with some
> followup paches.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
