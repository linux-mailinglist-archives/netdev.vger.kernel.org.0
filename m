Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FCC4E2FC2
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347809AbiCUSQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352050AbiCUSQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:16:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 373BC124C3D
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647886526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jugMr6N6v4Sah5zAzxwovwPPfOBTHWwUQ3pPphribxU=;
        b=Rhhzzw73Zb0FzpMNbA9USjf8BGLLun9yV9/o5cMxJNVI+YBfzyrZY5ZyG4CV+Ob/O3iWKl
        g68IKID9CsawkKowCLuUT8eDGCdS6hO+mOD1SgwaWPHn1VAGPDhmT/sEC1tpExC6CQa9FQ
        h0TqC2gxa/Vr39d5EqUA7VHdAnVjVh8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-se-ajDwENfSkhsU8WjjuTg-1; Mon, 21 Mar 2022 14:15:24 -0400
X-MC-Unique: se-ajDwENfSkhsU8WjjuTg-1
Received: by mail-wr1-f70.google.com with SMTP id d17-20020adfc3d1000000b00203e2ff73a6so3100498wrg.8
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jugMr6N6v4Sah5zAzxwovwPPfOBTHWwUQ3pPphribxU=;
        b=nEp1rugN9v8e+h1D9PdhQpkXQKCdcWPSwxIkACbRewelOxwJ9qqSdCa4WdsbEmSF2X
         DzK4EFxw0bGLQ0eGiJknF+olmB2Wb81UCVwwaZeOgG1Oy6eaA+H3VDpVmEOgaI7zE5S4
         uVqwisLD9QFchcpcQH8ZqFtUQcq94ynUh/K4KiDSTCh4O+qFK/84djNAHbXv61H8nJQS
         dLoPHggx/iyk+R3ekRiB6FrfVcHuKPe2zbHwJfnQJKk7KT/L4Le7BkIzSpxe4jDIDibP
         roTgwI6eE6QPOeEyer4R4fLJq5xY/3FTc36WcfC2b9kaTch1Kmum2EHoM6wh1jIhwE5a
         erJg==
X-Gm-Message-State: AOAM530Lh5jMAvIRGJAeBLXv1e0aDKdY110wXMWM1iyJj9nB8fNzISJ/
        0mukLv6xvANjq6AxBO12SJV90p1dHTGTd6OG81eJoGeI05YzX1dFfkA4aNaQXmhKokrvUce71WP
        0ljAFmVpnHoxGyU06
X-Received: by 2002:a1c:f607:0:b0:38c:8d54:e16f with SMTP id w7-20020a1cf607000000b0038c8d54e16fmr336214wmc.36.1647886523394;
        Mon, 21 Mar 2022 11:15:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLo71gKYR6zaD4Vt5J03/37dXbFWgsv3NzCX2ksMcZKavxZtY2HKtx8lvFrt8zcAD5TQWVKw==
X-Received: by 2002:a1c:f607:0:b0:38c:8d54:e16f with SMTP id w7-20020a1cf607000000b0038c8d54e16fmr336196wmc.36.1647886523124;
        Mon, 21 Mar 2022 11:15:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id v2-20020adf8b42000000b001edc38024c9sm15344280wra.65.2022.03.21.11.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:15:22 -0700 (PDT)
Message-ID: <f8a4117900f09cd1b5f6c51d6a7299549d7cd3c1.camel@redhat.com>
Subject: Re: [PATCH v2] ipv6: acquire write lock for addr_list in
 dev_forward_change
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Ahern <dsahern@kernel.org>,
        Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 21 Mar 2022 19:15:21 +0100
In-Reply-To: <5bda97a3-6efc-4ce2-859a-be44f3c2345e@kernel.org>
References: <20220317155637.29733-1-dossche.niels@gmail.com>
         <7bd311d0846269f331a1d401c493f5511491d0df.camel@redhat.com>
         <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
         <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
         <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
         <0cf800e8bb28116fce7466cacbabde395abfac4f.camel@redhat.com>
         <8b90b4a6-a906-0f46-bb87-0ec51c9c89fe@gmail.com>
         <5bda97a3-6efc-4ce2-859a-be44f3c2345e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-21 at 09:42 -0600, David Ahern wrote:
> On 3/19/22 7:17 AM, Niels Dossche wrote:
> > I have an additional question about the locks on the addr_list actually.
> > In addrconf_ifdown, there's a loop on addr_list within a write lock in idev->lock
> > > list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list)
> > The loop body unlocks the idev->lock and reacquires it later. I assume because of the lock dependency on ifa->lock and the calls that acquire the mc_lock? Shouldn't that list iteration also be protected during the whole iteration?
> > 
> 
> 
> That loop needs to be improved as well. Locking in ipv6 code is a bit
> hairy.

I *think* we could re-use the if_list_aux trick: create a tmp list
under idev->lock using ifa->if_list_aux and traverse (still using the
_safe variant) such list with no lock.

Still in addrconf_ifdown(), there is a similar loop for
'tempaddr_list'.

In the latter case I think we could splice the idev->lock protected
list into a tmp one and traverse the latter with no lock held.

@Niels: could you look at that, too?

Thanks!

Paolo

