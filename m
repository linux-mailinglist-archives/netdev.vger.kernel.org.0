Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EAC6D0DA2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjC3STz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjC3STw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:19:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE0EF744
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:19:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id c4so2048653pjs.4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680200391; x=1682792391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kqiQQpp63U4POCKet0PaeQJUxUB8thf0z1OCLO+3k0s=;
        b=ZEn4t+89KmeWwOgbLEnJ1pFmmTpttRZ/MLKElD7kYM+v+a5RqezhKAQRboK/xeT8lH
         cPXZW+wV7K3gmvC/PSZTpkH2vVRm5RNykqxROZwJh7nN0PT+2HnVxGFqakSvzrJbxMpG
         9FSM6Odki8X+X5ILdhYWk9lWzOk3V5tRnYnE9eh2cpYrrS3qAqf1MKKudGPQLSlBbKND
         HNzeIxLtZX/FtqFE23xc1YLQGypp7SrYDhzbpqwIqpi81e1O0wQCG2bOWW9XHx2yaITD
         CLBJAGUJMpHEkToF3usaGdnrU5Ipasj+VxixcdMBbWFPKyWv+Gz8pYBZmGfsXJVZehbo
         mobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680200391; x=1682792391;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kqiQQpp63U4POCKet0PaeQJUxUB8thf0z1OCLO+3k0s=;
        b=1IbZBDQW8uprlNXGv0it7Ouz5nvwkYgw5u1GfSBnAMz8OQKvlFFbLcKuxHfNqPhgjJ
         QMECSRuI6Sxxhp+yr4l//FI2Li6p6S0DHpRVOE2NLo6dvnKxU+eCjYIbkLEU15Ky5v6H
         Nzb76BvdvkZz2F+8v3AwvuwGtNf0ByYTZ2HedlQN7MC+fZiZHvT8lCZX7MjUM1Vc93DS
         EoLoe4VIst9sYVOAyzE5dHdrkTriAfPal1MxKpRWtPsUmUoZ2RzHY0+wzqqMS4Yyswxh
         FvdtD85FfVSd7v+BxKcBxSmSo4pQwZjRkZ3aZOw4YzYPgX2GxlYblJELMgjEV5ZctF5g
         XUJA==
X-Gm-Message-State: AAQBX9ccb1mo8PPuVoa0aTrAnAVHRyivoZZ3Jg2EuKEctC/J0OFougw2
        MQ21SvdasYBQ+9tJP26o7Yw=
X-Google-Smtp-Source: AKy350ZeTlxFI1qJnk9hUcx9unhG7rNLotxVUayYOX3H9kCr3UFtK3wPE46ytY19frTBz+NbZx0Ppw==
X-Received: by 2002:a17:90b:1a8b:b0:23f:4370:2c67 with SMTP id ng11-20020a17090b1a8b00b0023f43702c67mr26382284pjb.26.1680200390638;
        Thu, 30 Mar 2023 11:19:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n12-20020a17090ac68c00b00230b8431323sm3580921pjt.30.2023.03.30.11.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 11:19:50 -0700 (PDT)
Message-ID: <a670e4b9-0db4-1beb-9b46-98d077d91c70@gmail.com>
Date:   Thu, 30 Mar 2023 11:19:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net: dsa: fix db type confusion in host fdb/mdb
 add/del
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
References: <20230329133819.697642-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230329133819.697642-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/23 06:38, Vladimir Oltean wrote:
> We have the following code paths:
> 
> Host FDB (unicast RX filtering):
> 
> dsa_port_standalone_host_fdb_add()   dsa_port_bridge_host_fdb_add()
>                 |                                     |
>                 +--------------+         +------------+
>                                |         |
>                                v         v
>                           dsa_port_host_fdb_add()
> 
> dsa_port_standalone_host_fdb_del()   dsa_port_bridge_host_fdb_del()
>                 |                                     |
>                 +--------------+         +------------+
>                                |         |
>                                v         v
>                           dsa_port_host_fdb_del()
> 
> Host MDB (multicast RX filtering):
> 
> dsa_port_standalone_host_mdb_add()   dsa_port_bridge_host_mdb_add()
>                 |                                     |
>                 +--------------+         +------------+
>                                |         |
>                                v         v
>                           dsa_port_host_mdb_add()
> 
> dsa_port_standalone_host_mdb_del()   dsa_port_bridge_host_mdb_del()
>                 |                                     |
>                 +--------------+         +------------+
>                                |         |
>                                v         v
>                           dsa_port_host_mdb_del()
> 
> The logic added by commit 5e8a1e03aa4d ("net: dsa: install secondary
> unicast and multicast addresses as host FDB/MDB") zeroes out
> db.bridge.num if the switch doesn't support ds->fdb_isolation
> (the majority doesn't). This is done for a reason explained in commit
> c26933639b54 ("net: dsa: request drivers to perform FDB isolation").
> 
> Taking a single code path as example - dsa_port_host_fdb_add() - the
> others are similar - the problem is that this function handles:
> - DSA_DB_PORT databases, when called from
>    dsa_port_standalone_host_fdb_add()
> - DSA_DB_BRIDGE databases, when called from
>    dsa_port_bridge_host_fdb_add()
> 
> So, if dsa_port_host_fdb_add() were to make any change on the
> "bridge.num" attribute of the database, this would only be correct for a
> DSA_DB_BRIDGE, and a type confusion for a DSA_DB_PORT bridge.
> 
> However, this bug is without consequences, for 2 reasons:
> 
> - dsa_port_standalone_host_fdb_add() is only called from code which is
>    (in)directly guarded by dsa_switch_supports_uc_filtering(ds), and that
>    function only returns true if ds->fdb_isolation is set. So, the code
>    only executed for DSA_DB_BRIDGE databases.
> 
> - Even if the code was not dead for DSA_DB_PORT, we have the following
>    memory layout:
> 
> struct dsa_bridge {
> 	struct net_device *dev;
> 	unsigned int num;
> 	bool tx_fwd_offload;
> 	refcount_t refcount;
> };
> 
> struct dsa_db {
> 	enum dsa_db_type type;
> 
> 	union {
> 		const struct dsa_port *dp; // DSA_DB_PORT
> 		struct dsa_lag lag;
> 		struct dsa_bridge bridge; // DSA_DB_BRIDGE
> 	};
> };
> 
> So, the zeroization of dsa_db :: bridge :: num on a dsa_db structure of
> type DSA_DB_PORT would access memory which is unused, because we only
> use dsa_db :: dp for DSA_DB_PORT, and this is mapped at the same address
> with dsa_db :: dev for DSA_DB_BRIDGE, thanks to the union definition.
> 
> It is correct to fix up dsa_db :: bridge :: num only from code paths
> that come from the bridge / switchdev, so move these there.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

