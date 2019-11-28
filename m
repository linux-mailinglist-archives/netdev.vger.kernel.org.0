Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC43710C342
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 05:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfK1Ekh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 23:40:37 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:40371 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1Ekg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 23:40:36 -0500
Received: by mail-il1-f178.google.com with SMTP id b15so20537ila.7
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 20:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=q9yzU1nYNlf3EJM75747Cx3LdBPKXTXcGE0L7vaL7BY=;
        b=ekiQQ4h6gswaEjG1c8OQCVp24V6IBRM+R2KhLms+6VfiUNzBNxSxaOYuW8wTifazyN
         YtDoHmB0Ey4rr7pI9KLYtIgTviR+8tsp/vLWHROtrqe0NWRKi7AunE9kk3/mxyHNcs1w
         EGOtt62vWBjz77BwAL8dG8aGY6E5L+RGQxpkxHNAoZJmxY9FHNaam8zVqhtaEVkGmzH5
         uhPdNDILWyUCt0m8MwO5Z0DCrFk4GdQAmVMw1Z1B0PhlV2fAzO/Fr8XgzHaZFaQsYesl
         jirgLGjKD2XMpJ6su71oV60bq8McBNIIxkcHF4ZCUr5HkJaIOVXjeA7bqClej0SfW++2
         FIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=q9yzU1nYNlf3EJM75747Cx3LdBPKXTXcGE0L7vaL7BY=;
        b=O+1iINp1sLwJwIdzo+BrM1FmOV6QCEKVNNY242hmRp7SvagInKhAKiMuBAbuBnEoE0
         ypbxXyiZ4FedeSw6o8vc99JcvcvWGr0/ekBXR9AHOkVpccVfm8iCglDLRoN3o/gRRTGv
         5XsANDZZUKlNpRkQWC7JSBgbW97i8MTTbGmAP3pVHBcvIf4poymY0Wt5xkgNi0cbNmhB
         duSry/sErgQbAZSVzLs7NuqeGOEenUSjY30hOhuPqeHr1GLnoBLWI0MKR9KMHCD59c9O
         pXgxEnPaIMX641qS+m9IvQ/2AW8EWeGTdLIK6SUfLT0F5Ev8UVDXvi7gTJK0dW23uQQ+
         aXOA==
X-Gm-Message-State: APjAAAVUNzTMGqlkG4eVgZmZU1vpMFmFhSSG484UslxyeaOFt1abb8HG
        rw0Idhgo/Sx/pyxbpQo2ZWk=
X-Google-Smtp-Source: APXvYqz/VOpqljQRVnaERzS0/qt3L3+CKz1gCmNAFRPLMI0Lwql7tl+NVcfYohdNN46HIHKUos1IKA==
X-Received: by 2002:a92:b70c:: with SMTP id k12mr47885447ili.55.1574916034322;
        Wed, 27 Nov 2019 20:40:34 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t4sm5067849ilh.29.2019.11.27.20.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 20:40:33 -0800 (PST)
Date:   Wed, 27 Nov 2019 20:40:26 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net,
        john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Message-ID: <5ddf4fba39b92_3c082aca725cc5bc5e@john-XPS-13-9370.notmuch>
In-Reply-To: <20191127201646.25455-2-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
 <20191127201646.25455-2-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net 1/8] net/tls: take into account that
 bpf_exec_tx_verdict() may free the record
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> bpf_exec_tx_verdict() may free the record if tls_push_record()
> fails, or if the entire record got consumed by BPF. Re-check
> ctx->open_rec before touching the data.
> 
> Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  net/tls/tls_sw.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Acked-by: John Fastabend <john.fastabend@gmail.com>
