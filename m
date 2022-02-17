Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A934B97A9
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiBQE1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:27:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiBQE1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:27:03 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE8C7665
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 20:26:47 -0800 (PST)
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EAD453F328
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645071999;
        bh=jI0Eorm2P84NavSX0yjyan+TX9aSac4Uc8bKjg/CeNo=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=ifQejb+tFJC/VB/aFuiK+6yNgxFwlIOFIRA0yOSTmREMaI6ZsxYqE1Se8vSgP4sLH
         0EpsrQ6Yb+Kpa2gOtxPm+UTTx4aPcF5odp2HEeQctIAEOAZhZoZzEgqYoQfFi7xBt8
         /VJAvw2zUXsYdE9Gt6v11ydM+wRMMyZaFYFIe2ggt1jg1andRb4vqhjw8Vuv7XIkLw
         cnQWwnINPkJXBdb99y6/ZxuErdoaWPCuBhmkK3M6RR0iD1bqveP0Wb0ko8d7DJaQBe
         NAsqiisRAYQMFIRjdqeVUNTX+b+kMrfUehQcJapXRxQIq3MBmRS6bHXl6eplskuIc8
         aOy0JuYxgHgow==
Received: by mail-pf1-f199.google.com with SMTP id n135-20020a628f8d000000b004e16d5bdcdbso2528529pfd.20
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 20:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=jI0Eorm2P84NavSX0yjyan+TX9aSac4Uc8bKjg/CeNo=;
        b=PRLU10Dc2VEIK6QJC27M7kEx2RdD7MpttxczCqyQNM6gLPwJCtRU7t4VaBrb1GnY/x
         tiqKz7lU1e172xvTQq2kOAztZNMiChbh1QVeGGwXsmPleC7++iIkSalobgNmEvFB0KyY
         6/cRfqpjayVaa9xR2j/UW9Nn+8dYuBcdGczZG1MNWrKyja8eWrHaOufVha7MYOYp44Om
         FGf7JuG0UlPmfxG+zmoIiR9xN0e+Uhq3fguxGommmbYCUag32EmljWmVmCX9E6XRQrNH
         yoDJw2CKBcIhf/947NZ9JwdoBhe0xrNO3ct/ZXQir4Y+a5KK2RTbzvImlC9k6rnU0VRo
         NXmA==
X-Gm-Message-State: AOAM533Kl3jDNKpc0qJ5ZS7I2y9B0oq5UwPpvOzqTfKc6IxCIFiE2EZM
        SPmUe4aCmX3OI29UEJFgeBT9E0YojUZDYdd8Xq0jgYmrOuaAdS6Nnz1DFtLgyA4JUOGRVtxAJUY
        fmNdB4uiyG7F/F0836zg7KK4qdUfNks0tTw==
X-Received: by 2002:a63:4d60:0:b0:36c:8803:b92d with SMTP id n32-20020a634d60000000b0036c8803b92dmr1020661pgl.179.1645071998569;
        Wed, 16 Feb 2022 20:26:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxorCa4dC/mvPvgKXMM7/O3s7SVqolIkYYsM5DIHUwLOpjz40eSeGsw7k1ELd+MJtSM6SuAGQ==
X-Received: by 2002:a63:4d60:0:b0:36c:8803:b92d with SMTP id n32-20020a634d60000000b0036c8803b92dmr1020650pgl.179.1645071998271;
        Wed, 16 Feb 2022 20:26:38 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id v10sm11713955pfu.38.2022.02.16.20.26.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Feb 2022 20:26:37 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 6246760DD1; Wed, 16 Feb 2022 20:26:37 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 5CC14A0B26;
        Wed, 16 Feb 2022 20:26:37 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     David Ahern <dsahern@gmail.com>
cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>
Subject: Re: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
In-reply-to: <cc2e5a64-b53e-b501-4a08-92e087d52dda@gmail.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com> <20220216080838.158054-6-liuhangbin@gmail.com> <c13d92e2-3ac5-58cb-2b21-ebe03e640983@gmail.com> <Yg2kGkGKRTVXObYh@Laptop-X1> <cc2e5a64-b53e-b501-4a08-92e087d52dda@gmail.com>
Comments: In-reply-to David Ahern <dsahern@gmail.com>
   message dated "Wed, 16 Feb 2022 18:36:49 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8861.1645071997.1@famine>
Date:   Wed, 16 Feb 2022 20:26:37 -0800
Message-ID: <8863.1645071997@famine>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:

>On 2/16/22 6:25 PM, Hangbin Liu wrote:
> > For Bonding I think yes. Bonding has disallowed to config via
>module_param.
>> But there are still users using sysfs for bonding configuration.
>> 
>> Jay, Veaceslav, please correct me if you think we can stop using sysfs.
>> 
>
>new features, new API only?

	I'm in agreement with this.  I see no reason not to encourage
standardization on iproute / netlink.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com




