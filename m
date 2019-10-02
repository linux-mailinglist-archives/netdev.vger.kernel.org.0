Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4268C901D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 19:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfJBRoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 13:44:06 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53604 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBRoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 13:44:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so8120643wmd.3
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 10:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xobYEG0AEaPhaGje+6DN+Ep8BZLhFrNhLiVQA67AVaE=;
        b=yrnWKsjLScjxxNWKS8/eQkCGaAkjM4/CI4WwiB4JXJKI37bSyoXntwqQdEZI5t1AFZ
         k7qVt9hXJKqEZt5VWZ3dKNZYJp7vETCaPGh/YQEP2QyjiyHiQ1SsvwtKqVAhC3Lw7ZaS
         iBSEjf3DkIZCYZplbSGvrJzJyxv1EhAbOztLMSCaEOX5tMD8ijUsCrejiR3D/3ZcDOOv
         L81NEPuZjhUc0RX1jFili9CfwuajQQGrYDp36V36q8VB84forWk3MhvmbIFe3jA4Tskv
         JP1vZ71qm2kcaYIXLvaVHxqkv7ySqILpxC/2sh6IAoR5w9xMkNh2oFKEbfya1UDbM5le
         9UOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xobYEG0AEaPhaGje+6DN+Ep8BZLhFrNhLiVQA67AVaE=;
        b=GgUbriHe7SyGgy0DFcvRC2eQYKAQpJx3adrM8No0F6nw+I6TtPwuIVdn1q4QRWKSo1
         rF1AHqviFtvLcl5iE0LS619V54TZAg8OPlCmCpct7Rp4FrpZZtJ97i/peVRpsOH4iiR5
         JMaoFSdyFVl7lvLn8R6uro4yCeyRBarspG7yc5KpEUaCfB51VdtrKJ09Mfc01BjSC2Ev
         jVVbtSK2i3Qyx7oixJVj8fr9yXhW/A3R4QJwmpT4frQy1AjuBPde/SGehUAHB3zuBGsn
         bCri4Kt5trBkkY2FLO3hcOZ54GuarQAqn7XazFwz3qf3nao13oLQ/8X1U2Bo9B/cpubo
         wrrw==
X-Gm-Message-State: APjAAAW3QBY+y/FsPHkjm2u/65rC3meG3EK/OJqmrv2ns9DL5l+rO7VZ
        qVd6DysdI3kYv/BcF9NHTrwYOA==
X-Google-Smtp-Source: APXvYqzi7LiPSBq7paxrDKIZWpAO7XEm5V68Te8WmxmWr/NONhS1syCyo6iPvAcRTHCB5ZMngSlpZw==
X-Received: by 2002:a1c:c589:: with SMTP id v131mr3667706wmf.163.1570038243687;
        Wed, 02 Oct 2019 10:44:03 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c9sm97071wrt.7.2019.10.02.10.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 10:44:03 -0700 (PDT)
Date:   Wed, 2 Oct 2019 19:44:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 07/15] ipv4: Only Replay routes of interest
 to new listeners
Message-ID: <20191002174402.GB2279@nanopsycho>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002084103.12138-8-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002084103.12138-8-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 02, 2019 at 10:40:55AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>When a new listener is registered to the FIB notification chain it
>receives a dump of all the available routes in the system. Instead, make
>sure to only replay the IPv4 routes that are actually used in the data
>path and are of any interest to the new listener.
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> net/ipv4/fib_trie.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
>index dc4c4e2cb0b3..4937a3503f4f 100644
>--- a/net/ipv4/fib_trie.c
>+++ b/net/ipv4/fib_trie.c
>@@ -2096,6 +2096,7 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
> 			   struct netlink_ext_ack *extack)
> {
> 	struct fib_alias *fa;
>+	int last_slen = -1;
> 	int err;
> 
> 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
>@@ -2110,6 +2111,15 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
> 		if (tb->tb_id != fa->tb_id)
> 			continue;
> 
>+		if (fa->fa_slen == last_slen)
>+			continue;

Hmm, I wonder, don't you want to continue only for FIB_EVENT_ENTRY_REPLACE_TMP
and keep the notifier call for FIB_EVENT_ENTRY_ADD?


>+
>+		last_slen = fa->fa_slen;
>+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE_TMP,
>+					      l->key, KEYLENGTH - fa->fa_slen,
>+					      fa, extack);
>+		if (err)
>+			return err;
> 		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
> 					      KEYLENGTH - fa->fa_slen,
> 					      fa, extack);
>-- 
>2.21.0
>
