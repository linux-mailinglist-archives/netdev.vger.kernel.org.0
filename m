Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0CE4EDB4
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 19:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFURQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 13:16:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33806 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfFURQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 13:16:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so7345026wrl.1
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 10:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jgV/XkgN8Y9Fj5/fSBMw8BZRMaC0+jUlz3JahVp2x1I=;
        b=XhiprkWxlA59OOVMHQQOMf/yudIJSGjDIfKLtQzQup0CBEwUqqE75hBaYJRZg4DKT+
         CsgyWFYGLjGg3Gg+vfvZCa5sL3jnFKUpDRkHyme4Fq99HhGPimS0S68Pqt0gzOR4WmYz
         /9ty89u18TQGpuhHcqjMhgizTlX44/0xQhxpT8rC6G/8Hoo0NT1Q9rlrr2caST44yadc
         2K4+kWD2TM44PTzZw3e8zTIbGNafOLQRnXp/+qzdCPMvpmECPmvxhT7M8ynoO6k7SJYV
         DYGVRTX6kTn5s44GRHSe6SpmiYFU7jKnWL+GFVVLyLa1mTkC69Li9eVpxwjXOLDUkiyw
         VZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jgV/XkgN8Y9Fj5/fSBMw8BZRMaC0+jUlz3JahVp2x1I=;
        b=WNidp+8HE4UeVzpuy6sx6/drVvToSZbCKByRyGqw7CbaOitbKJeuImewLMJjrBJcrR
         eHNKwwIWeY0gZ9pZjS8Uta6I2kzSlVfifKgp7+HkLUfKts4cpHTqUBUunJmqiEP2PjSv
         9BHC3lA8bdOgp2SItNNI4AUbQJai5/sObjzAVjxECFffkKQ6Bd9TAMvyUMg0WJs8OWxg
         /0KR52ZZNVcr7etl49Eur9ii67cuL4nDHlvoGg/IMDJv84MHP0wUmgkzH1pxbIE6Hjmy
         Ve10hhKAoXe6oOW3N+XlxOfF11Z1sFAgCWg+BQerPftfdeMEHrpRDludWAJXdcFqDeXz
         /xXw==
X-Gm-Message-State: APjAAAVKtxZxfDe/skDRyTqKRTgVRiLAkD0L4XdD/hP1y0YCZxInKZiG
        Bkxh0/u+rlVfwrfM6Nn+4wqLlQ==
X-Google-Smtp-Source: APXvYqy8B0voVnj1fYtLGS43M2RGVe0wRadUUHbkQh89ge1T7Q9V4Ey+MrKwl1Y4Wsx1zJx59BFD6A==
X-Received: by 2002:adf:f246:: with SMTP id b6mr38171497wrp.92.1561137364493;
        Fri, 21 Jun 2019 10:16:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 90sm6151623wrn.97.2019.06.21.10.16.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 10:16:04 -0700 (PDT)
Date:   Fri, 21 Jun 2019 19:16:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 04/12] net: sched: add tcf_block_setup()
Message-ID: <20190621171603.GF2414@nanopsycho.orion>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-5-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 20, 2019 at 09:49:09PM CEST, pablo@netfilter.org wrote:

[...]

> 
>+static LIST_HEAD(tcf_block_cb_list);

I still don't like the global list. Have to go throught the code more
carefully, but why you can't pass the priv/ctx from tc/netfilter. From
tc it would be tcf_block as it is now, from netfilter something else.
