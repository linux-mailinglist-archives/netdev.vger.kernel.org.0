Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA1FA2135
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfH2QoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 12:44:12 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:41677 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfH2QoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 12:44:12 -0400
Received: by mail-ed1-f49.google.com with SMTP id w5so4747782edl.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 09:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J0mIptJpgCrji3rnOXUkwAg2sK122VXt0E9fIlxztOM=;
        b=CjUWiJmEnPc7cpwJ/wsprTOwzmCKVjptR7CYO147EQ8lCVLk9PNsUUNihGjDi0yAiU
         AdhSK4kl0aEt2i34anAuJ5CHeotYjHF8tIYEm3pizhouRuUK1YrIQE9k7itxJ0YcnexA
         2xxmCkBC+zU1PddIE30q0E+GQLwS5xXelvTGwgwTgCRHUc1mpEfEbNdN9FaevS84+w0A
         KKda+pmQs9qgR1c9qFKdc00Mlryh7p5phtUGHaZ50O+d2E8lL9LWq8PdysrjSDlD/08l
         rDCf6VUX8OHUCdYLvFfNVFqqKJyeiQ3PwuqXv0ooKBfDDDwygOUbgOX0gZqeldc+118y
         0m1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J0mIptJpgCrji3rnOXUkwAg2sK122VXt0E9fIlxztOM=;
        b=XO6Uo+n5BeJ7D8aiyPMQOjqQ/JDhgtjwXMGLIQlqqdQ6DpWOTj3Dl7ktMtQSJdmGAO
         ufvylbMpuS48Yd3s2Hd3+o8i3PqF7Heglw1pTZpKhXeVqHnd1ipiwaY2f3qLNH6SejLS
         cWiG0tyH1OTaNYTc2r3AaeunwY+WUIKRioV5ipIk30wUdbAg+9hi/59CtzB3McAQtS1J
         6MWzjEhJZ/ouJbixBseD8H4dgA3q8DTdXnr6Br1HYOcmeM4Gtj+RtGslCgGVTnPdN/A0
         glmCgXPRjygnhSapnjQTXT7oPeNMuBVhxGxxdXyDxmrTjxdmK1UmatdUfIq/FciyxKCg
         j6lQ==
X-Gm-Message-State: APjAAAUhXX9TcSDNUWVkVHzQ5pc6JqFwQfWXPqiCYGXvtHD5VHimTwv6
        ndbxmCifo21+MQle4Epoj6unMg==
X-Google-Smtp-Source: APXvYqw5Xs+f6YJcpXnaAvDOyRlabm5hOEmNVZx7gCr2PPOar2OUA5f1/a+08qrVc12CFDoVIZHybA==
X-Received: by 2002:a50:884b:: with SMTP id c11mr10893613edc.138.1567097050284;
        Thu, 29 Aug 2019 09:44:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o11sm444273ejd.68.2019.08.29.09.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 09:44:09 -0700 (PDT)
Date:   Thu, 29 Aug 2019 09:43:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     john.fastabend@gmail.com,
        syzbot <syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in tls_sk_proto_close (2)
Message-ID: <20190829094343.0248c61c@cakuba.netronome.com>
In-Reply-To: <20190829035200.3340-1-hdanton@sina.com>
References: <000000000000c3c461059127a1c4@google.com>
        <20190829035200.3340-1-hdanton@sina.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:52:00 +0800, Hillf Danton wrote:
> Alternatively work is done if sock is closed again. Anyway ctx is reset
> under sock's callback lock in write mode.
> 
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -295,6 +295,8 @@ static void tls_sk_proto_close(struct so
>  	long timeo = sock_sndtimeo(sk, 0);
>  	bool free_ctx;
>  
> +	if (!ctx)
> +		return;
>  	if (ctx->tx_conf == TLS_SW)
>  		tls_sw_cancel_work_tx(ctx);

That's no bueno, the real socket's close will never get called.
