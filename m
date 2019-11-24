Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDF10820A
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 06:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfKXFjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 00:39:06 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:33514 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfKXFjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 00:39:06 -0500
Received: by mail-io1-f41.google.com with SMTP id j13so12598880ioe.0;
        Sat, 23 Nov 2019 21:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2kSiw9kMso9p+29M/hRsPrTs7OL/+vhoLZ54ylyfi3s=;
        b=SicpO2MDrres8TxP1T1e+i8zz3kjRSnecaPIZBdpUxr/dR3sHgCde9lATzPn80gfOT
         TlLxHz8LVdHmZelrx0JP894b0eKUKgWbEg5pNNv1gtzRHmPg/bXgtlB74JXyrwtDo2fK
         zCBYKNslABBCSZp1vKnc4VY/EUaQmU/VcF/ufzHT7RQm3eelX4tun29yfx/KTJLIGuH3
         calplqJhTMOVF2ingfKybGv07lK1XeqsKePVQcP+GS95T01gxJTzDYhlWk7SVjAgHSE1
         24j4mqFESzcVtTb2UvfEskLEQHwLASBpQNSzMHzAjOQXa18t9c6QdP/D7hNqTwCHYAai
         j84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2kSiw9kMso9p+29M/hRsPrTs7OL/+vhoLZ54ylyfi3s=;
        b=JvzIFc++Q6T2NShrr0myAiwft+3QzziYSXb48iwwuNNpeM16xW+PVD9Q4vj0GNnu5G
         8v/au4pz/Bv7hQOUROmx7cIdatNYPSmzqz6SPJ4GWe6ogFsVV1HxVmrtklsF8qVKzTuY
         OSIB5gIswAx1VI+HqcpOnBwKHxjT1oCj0FhOKw5ORtKd+gvoaheJF0+7NHWeuNZ8/coh
         9LV8LLq5GjeoSn55YXjlC0Qc60nNB6BJCFidQ3KFNELqnAyx3OgAz5upr0rU3y+6DjF7
         5yj9wrYCfdtheZ4bFbmoExb9Ok1yPXZAXWcuhPVugq/wK5hBeHrC2XSk+LoDsYS/6hJO
         qYoA==
X-Gm-Message-State: APjAAAU2YxFbSlbtDHu+gMHnrxKBQNuVHZsHObXcYz12yRwZBqxSpInD
        ZDO71eypwlW9lFLIKtOd56Y=
X-Google-Smtp-Source: APXvYqwgc9MoOMuwL2W8n2vE1Q5k/Sqk30DfYUunQrIBumE7cAU4tCYw1DQshf0i6JBfCUtTL2YiEg==
X-Received: by 2002:a6b:4f13:: with SMTP id d19mr19763910iob.181.1574573945722;
        Sat, 23 Nov 2019 21:39:05 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a19sm798625ioo.51.2019.11.23.21.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 21:39:05 -0800 (PST)
Date:   Sat, 23 Nov 2019 21:38:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda176ed4bcc_62c72ad877f985c4d4@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-4-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-4-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 3/8] bpf, sockmap: Allow inserting listening TCP
 sockets into SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> In order for SOCKMAP type to become a generic collection for storing TCP
> sockets we need to loosen the checks in update callback.
> 
> Currently SOCKMAP requires the TCP socket to be in established state, which
> prevents us from using it to keep references to listening sockets.
> 
> Change the update pre-checks so that it is sufficient for socket to be in a
> hash table, i.e. have a local address/port assigned, to be inserted. Return
> -EINVAL if the condition is not met to be consistent with
> REUSEPORT_SOCKARRY map type.
> 
> This creates a possibility of pointing one of the BPF redirect helpers that
> splice two SOCKMAP sockets on ingress or egress at a listening socket,
> which doesn't make sense. Introduce appropriate checks in the helpers so
> that only established TCP sockets can be a target for redirects.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.co,>
