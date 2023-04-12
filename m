Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213F06DEBD7
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDLGdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDLGdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:33:51 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7B159F2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:33:35 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 7234F3F43A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681281209;
        bh=90v5l0QUYxneg3zhLgrYtc9+4V6khLb2lMYoTRnCjac=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=DZb6zSuJhsu3uEv8ztWgY44MuH4sAK/c18HYYGN2+pxkDxdmBmo+bQkn6gCcivq0f
         6ehP3tEpUXdugAR48dS5DtmRaU/lxXNznvDMFb5YRTEqJrqXt83asmDYWVOm58dD9H
         04UzbkVlH7vPQZpKustK5nSpmHaGdrZtWkVAaLCug8YXimZL/s9d0uSJrkzBnw32nl
         eRv/KcADjj0/mwjsCtrcSnwMKtsR1T1vKwDCCHYkaLQFR3fXRND2nTpzo4KZlVQQ0+
         OfW7W+YhtpRGwv+g6JaFpvz7ZjAFJSFG5/RgG5IT/MmC7TN/c2j5A/ETYdy4ygbV8T
         nd/uWAY1wemSg==
Received: by mail-pl1-f200.google.com with SMTP id k7-20020a170902c40700b001a20f75cd40so6250201plk.22
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681281204; x=1683873204;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90v5l0QUYxneg3zhLgrYtc9+4V6khLb2lMYoTRnCjac=;
        b=YDgaQAUqvFodkk2yJmY3NbJkEAazr8qs4JrdySFx4ZL96Nmma60OYejXnRjQG6lB/r
         bWADbygEtyefbYMHgAF4jllfQPteaMaTJZ856rmS5ZVaDZOusRdRI4H+rzSEAl/jPmOR
         QNNPzqsWtQ/Yg3DeSlyt9H39dyxFN+8vnqIDC84/pnHx5nQQOxkx4kBfS0NGWPfyHpCa
         DtvnNaCdnTGnxg4dZ2IdLvPiFDL2nvidBTzgBlsYwaB7rGDLL/Nw1fQb+sJMlHsV0z7m
         7ezUJlfFDrHfvtHycEsVOaR3Q0P6zFKF1JOw6Ap7n1ePAd7tQlGFQ/ViJmTov659g9y7
         ba8Q==
X-Gm-Message-State: AAQBX9fzvx6Ja77nZb95FLkMrosKiLVv6xcGwtlnSUiMbPS8n2XpV0NP
        X1/VAcXI5E0Nm6+hqDJDwZDOagGdk7U2a2j0cjUzAa287dVi0Y6r1wcC7H8VrVKFLLnS7dfEyho
        YyNp5XsEod+wq/Hv5SyJ+aGJcRUx8ZiMyWg==
X-Received: by 2002:a17:90a:2ecb:b0:247:2e1:b571 with SMTP id h11-20020a17090a2ecb00b0024702e1b571mr294433pjs.49.1681281204526;
        Tue, 11 Apr 2023 23:33:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350awfpqrZlAlb2bg/gE6dB/vBf2EC7YtTen/Hbf/aYo4xHvwxtfORQcL6/pI2NfUZuGAR/DaZw==
X-Received: by 2002:a17:90a:2ecb:b0:247:2e1:b571 with SMTP id h11-20020a17090a2ecb00b0024702e1b571mr294413pjs.49.1681281204241;
        Tue, 11 Apr 2023 23:33:24 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090aa10c00b00246f856d678sm665626pjp.1.2023.04.11.23.33.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Apr 2023 23:33:23 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 5574361E6E; Tue, 11 Apr 2023 23:33:23 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 502629FB79;
        Tue, 11 Apr 2023 23:33:23 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv3 net-next] bonding: add software tx timestamping support
In-reply-to: <20230411213018.0b5b37ec@kernel.org>
References: <20230410082351.1176466-1-liuhangbin@gmail.com> <20230411213018.0b5b37ec@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Tue, 11 Apr 2023 21:30:18 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32193.1681281203.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 11 Apr 2023 23:33:23 -0700
Message-ID: <32194.1681281203@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Mon, 10 Apr 2023 16:23:51 +0800 Hangbin Liu wrote:
>> @@ -5707,10 +5711,38 @@ static int bond_ethtool_get_ts_info(struct net_=
device *bond_dev,
>>  			ret =3D ops->get_ts_info(real_dev, info);
>>  			goto out;
>>  		}
>> +	} else {
>> +		/* Check if all slaves support software rx/tx timestamping */
>> +		rcu_read_lock();
>> +		bond_for_each_slave_rcu(bond, slave, iter) {
>> +			ret =3D -1;
>> +			ops =3D slave->dev->ethtool_ops;
>> +			phydev =3D slave->dev->phydev;
>> +
>> +			if (phy_has_tsinfo(phydev))
>> +				ret =3D phy_ts_info(phydev, &ts_info);
>> +			else if (ops->get_ts_info)
>> +				ret =3D ops->get_ts_info(slave->dev, &ts_info);
>
>Do we _really_ need to hold RCU lock over this?
>Imposing atomic context restrictions on driver callbacks should not be
>taken lightly. I'm 75% sure .ethtool_get_ts_info can only be called
>under rtnl lock off the top of my head, is that not the case?

	Ok, maybe I didn't look at that carefully enough, and now that I
do, it's really complicated.

	Going through it, I think the call path that's relevant is
taprio_change -> taprio_parse_clockid -> ethtool_ops->get_ts_info.
taprio_change is Qdisc_ops.change function, and tc_modify_qdisc should
come in with RTNL held.

	If I'm reading cscope right, the other possible caller of
Qdisc_ops.change is fifo_set_limit, and it looks like that function is
only called by functions that are themselves Qdisc_ops.change functions
(red_change -> __red_change, sfb_change, tbf_change) or Qdisc_ops.init
functions (red_init -> __red_change, sfb_init, tbf_init).

	There's also a qdisc_create_dflt -> Qdisc_ops.init call path,
but I don't know if literally all calls to qdisc_create_dflt hold RTNL.

	There's a lot of them, and I'm not sure how many of those could
ever end up calling into taprio_change (if, say, a taprio qdisc is
attached within another qdisc).

	qdisc_create also calls Qdisc_ops.init, but that one seems to
clearly expect to enter with RTNL.

	Any tc expert able to state for sure whether it's possible to
get into any of the above without RTNL?  I suspect it isn't, but I'm not
100% sure either.


>> +			if (!ret && (ts_info.so_timestamping & SOF_TIMESTAMPING_SOFTRXTX) =3D=
=3D
>> +				    SOF_TIMESTAMPING_SOFTRXTX) {
>
>You could check in this loop if TX is supported...

	I see your point below about not wanting to create
SOFT_TIMESTAMPING_SOFTRXTX, but doesn't the logic need to test all three
of the flags _TX_SOFTWARE, _RX_SOFTWARE, and _SOFTWARE?

	-J

>> +				soft_support =3D true;
>> +				continue;
>> +			}
>> +
>> +			soft_support =3D false;
>> +			break;
>> +		}
>> +		rcu_read_unlock();
>>  	}
>>  =

>> -	info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>> -				SOF_TIMESTAMPING_SOFTWARE;
>> +	ret =3D 0;
>> +	if (soft_support) {
>> +		info->so_timestamping =3D SOF_TIMESTAMPING_SOFTRXTX;
>> +	} else {
>> +		info->so_timestamping =3D SOF_TIMESTAMPING_RX_SOFTWARE |
>> +					SOF_TIMESTAMPING_SOFTWARE;
>
>...make this unconditional and conditionally add TX...
>
>> +	}
>>  	info->phc_index =3D -1;
>>  =

>>  out:
>> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_t=
stamp.h
>> index a2c66b3d7f0f..2adaa0008434 100644
>> --- a/include/uapi/linux/net_tstamp.h
>> +++ b/include/uapi/linux/net_tstamp.h
>> @@ -48,6 +48,9 @@ enum {
>>  					 SOF_TIMESTAMPING_TX_SCHED | \
>>  					 SOF_TIMESTAMPING_TX_ACK)
>>  =

>> +#define SOF_TIMESTAMPING_SOFTRXTX (SOF_TIMESTAMPING_TX_SOFTWARE | \
>> +				   SOF_TIMESTAMPING_RX_SOFTWARE | \
>> +				   SOF_TIMESTAMPING_SOFTWARE)
>
>..then you won't need this define in uAPI.

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
