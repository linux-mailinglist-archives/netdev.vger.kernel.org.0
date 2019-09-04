Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA86A79DB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfIDE1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:27:19 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:33676 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfIDE1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 00:27:19 -0400
Received: by mail-io1-f53.google.com with SMTP id m11so9263114ioo.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 21:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=oT1RDW3WtDavPe2D4YD5Z5P3x5sZaWycvyp13JkqAZQ=;
        b=MCs9LbTu7InOXGMyAqYsFCPTsHmr1fCmRAylP6f9bo62Ma2pmG5+VvQQNYAw4zOt6s
         ikZyQmFJaupXaUG04MNs7H5N4bsLmaEt+KHsCRKWE28tF13Zq6wD5fClqCK99vU/nqAG
         8qud1SdSz1+htT12hZ7ho0AqFjWjzvcQLutPz/NymyZg/UVOcx/SGtwAWdBvl6Zq2jX/
         DDAP5fUUeQUqz3+JCfRvKQN6fPUl8lb/4w8dJDpx7kQUfpMlLFkb/A8fdXHEWQFuLyqs
         oyOfe9E6yyr6G0Eh1aoTJM8T3z5FNomlDJzzVyJQDzDxfnu5DoxS0lu9GH4kwhGZuwzU
         9l0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=oT1RDW3WtDavPe2D4YD5Z5P3x5sZaWycvyp13JkqAZQ=;
        b=UzwD93qubmVZnReISPToyl7iiBVpN7qU4feh7mN56hQbHIwlIO2NfiAguqtw8ochnx
         FyJ4XQjcHQIbVGtkkmFbw3NK3djfXBWyeV9jq/UnkVPes45GzP+Ny+tlyZu7wXB5oRw+
         dfmHtugYK2bcey0pKvwSQUhwMGnirPP9UFr7kqhGZgsR0U3F/JF8kVYlkcJbIV1FtelG
         DOtazsT0tMKSZzywqaiQhO0KfvEKZcDYagHTw8dy00TmrxSTR+Yh003GgEaaO7xjPS65
         PzA/KnBw2x4HDrfyVNNUFQQccWMs/XKcFyWTGkOvbH42yuiF5oVey0nffgW+xdh6skpD
         X+WQ==
X-Gm-Message-State: APjAAAU9EoGfea76iTx3xt7f8mu/cjb+YFrUElazw4udMYkK7aE/d26S
        l60IB1TJ1HfabGskmdslJII=
X-Google-Smtp-Source: APXvYqxVbVdIVOuwxFxHqrjqyuGqcOQl4w3zeMbuWo2WlJOZSb3Sh7L95TED607P41OvfFHUPAX/yw==
X-Received: by 2002:a02:608:: with SMTP id 8mr11647809jav.88.1567571238444;
        Tue, 03 Sep 2019 21:27:18 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z14sm14309631iol.86.2019.09.03.21.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 21:27:17 -0700 (PDT)
Date:   Tue, 03 Sep 2019 21:27:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Message-ID: <5d6f3d193926e_de32af1eb5fc5b41a@john-XPS-13-9370.notmuch>
In-Reply-To: <20190903043106.27570-2-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
 <20190903043106.27570-2-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net-next 1/5] net/tls: use the full sk_proto pointer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> Since we already have the pointer to the full original sk_proto
> stored use that instead of storing all individual callback
> pointers as well.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---
>  drivers/crypto/chelsio/chtls/chtls_main.c |  6 +++--
>  include/net/tls.h                         | 10 ---------
>  net/tls/tls_main.c                        | 27 +++++++++--------------
>  3 files changed, 14 insertions(+), 29 deletions(-)
> 

I like it should probably do the same to tcp_bpf.c.

Acked-by: John Fastabend <john.fastabend@gmail.com>
