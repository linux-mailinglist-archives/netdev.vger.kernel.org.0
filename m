Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436C44D5CD9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbiCKIAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiCKIAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:00:16 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF44177D1C;
        Thu, 10 Mar 2022 23:59:13 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id w27so13701737lfa.5;
        Thu, 10 Mar 2022 23:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Mwdiioncj/l/cynziYaX1F6ed/Qr7hUrnVD41vK//OY=;
        b=NFol+J8jV+aPmMHdQfby2hgu/UECHYPTMby4XDMqFm2Dx3W0K15oIN3u/7h3B8HlAM
         XVYWOg7KIdNTdnce9miayjD42y6zEOCsjpzqcIHHJrAGvly+9o53fXqUJqm7etjTsB4i
         GkVsWujIJ5enwoNBRmgMg1gMFwpudEaRfea89eNVXAdpCd3ynMiJOGjTqwHDwRIu+LBX
         SCMJqY2RZ/Fo0G2w+8y/syFGrrrT8HtFXvGLoXAt/LEFXUklTKwX7FOfCZ5lAxIcyQwR
         X8kKP/ZC3tvWkem1uWTlzEg/HgrneNlPoQsC8EcFAwfEfngnV5IUBUlizXleOITgPxB3
         2F3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Mwdiioncj/l/cynziYaX1F6ed/Qr7hUrnVD41vK//OY=;
        b=ocq2hIXwl8cQWXgYRrLK8n9FlToeVcdVUUeMxnf5L0Q7nXwDnzL+HcbYO/Nb2i4LTd
         oImSELQ0uc3XJp0oY1elPOpJwwyMkPTs8AndRiNZsXIMXjpw0e9Ych8ViXRbCD9OCnyL
         rOh1xfgMFIObSzkhjVe9mjvIxnkir7qjdd1Os9F79r9TAzHoRxkaCS/JFB8gTpamRpVd
         IkjgGHgRK1aJhLEaeHzKa2DmRz5En4RfUQdw9uyV+ijb6b+Lv1lwG4O0L4dWAz7A1LTb
         oa/t63vMfZ817DThVSq0dIC7L/Eygu2GEvIgfcDgQgeLVwaIj6DIAgqA+G+rpeK3CDYC
         SYFw==
X-Gm-Message-State: AOAM5313avq5dVaX8h56ctcQ88WSmYPyKtJ5MzfE7ARd20Ct2yD1VHzZ
        vaLiVVpFxhAtgZyG4kobAlU=
X-Google-Smtp-Source: ABdhPJxSVNzm7fcZkugcNK25HRPd1LdcUjg89I2YlhZQDTS8+GKKmsNWC6+vP8ZvCqOjk1Vc+1UEzQ==
X-Received: by 2002:a05:6512:c07:b0:448:3b4b:2b75 with SMTP id z7-20020a0565120c0700b004483b4b2b75mr5297102lfu.283.1646985552193;
        Thu, 10 Mar 2022 23:59:12 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k17-20020a056512331100b00448303beb30sm1454320lfe.101.2022.03.10.23.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 23:59:11 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <YioRQpUTJ7WmTLXQ@lunn.ch>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <YioRQpUTJ7WmTLXQ@lunn.ch>
Date:   Fri, 11 Mar 2022 08:59:04 +0100
Message-ID: <86y21gvs1j.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 10, 2022 at 15:54, Andrew Lunn <andrew@lunn.ch> wrote:
>> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
>> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
>> +									    chip->ports[spid].port,
>> +									    &entry,
>> +									    fid);
>
>> +static int mv88e6xxx_find_vid_on_matching_fid(struct mv88e6xxx_chip *chip,
>> +					      const struct mv88e6xxx_vtu_entry *entry,
>> +					      void *priv)
>> +{
>> +	struct mv88e6xxx_fid_search_ctx *ctx = priv;
>> +
>> +	if (ctx->fid_search == entry->fid) {
>> +		ctx->vid_found = entry->vid;
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>> +
>> +int mv88e6xxx_switchdev_handle_atu_miss_violation(struct mv88e6xxx_chip *chip,
>> +						  int port,
>> +						  struct mv88e6xxx_atu_entry *entry,
>> +						  u16 fid)
>> +{
>> +	struct switchdev_notifier_fdb_info info = {
>> +		.addr = entry->mac,
>> +		.vid = 0,
>> +		.added_by_user = false,
>> +		.is_local = false,
>> +		.offloaded = true,
>> +		.locked = true,
>> +	};
>> +	struct mv88e6xxx_fid_search_ctx ctx;
>> +	struct netlink_ext_ack *extack;
>> +	struct net_device *brport;
>> +	struct dsa_port *dp;
>> +	int err;
>> +
>> +	ctx.fid_search = fid;
>> +	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid_on_matching_fid, &ctx);
>
> I could be reading this code wrong, but it looks like you assume there
> is a single new entry in the ATU. But interrupts on these devices are
> slow. It would be easy for two or more devices to pop into existence
> at the same time. Don't you need to walk the whole ATU to find all the
> new entries? Have you tried this with a traffic generating populating
> the ATU with new entries at different rates, up to line rate? Do you
> get notifications for them all?
>
>     Andrew

We have not tried your said test, but if a packet doesn't manage to
trigger a ATU miss violation interrupt, not much will happen as far as I
see. The device sending the packet will not get access, but if it sends
again (maybe after a short while), it can still trigger the ATU miss
violation interrupt and get access.
I think that the normal behaviour for a device would be to try and
connect, and if that is not successfull inside a short time, it will wait
for a timeout before trying again.
