Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4B05237DF
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiEKP4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiEKP4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:56:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED32B2BB0D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:56:22 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s16so2167686pgs.3
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7In0GU6wcgBJO6cgejycIAA7qvLikGPOVN/ipT1rQI=;
        b=Sqr3N0dgTj9I1/wUn2aEhLvld+PeVBUkyFEoCbeeinu2cmWVoD292LkG+5kdzYbV8p
         1q/HlNzo82k3T2Tx4rKoCTF6Buzrd8CSy271VobtMZ4xpeYXH6Gp1rXli/9LFlntG/LE
         YkNfcc5SLdBS1XFIERE9mWzxstt4JhsgtspgauvwQDLaCcCZzNzj8gA2c8exLCd20N47
         Db96288kGl4mEot6ZI1R1mRaQmEpPm+K3IkdcUWekLpkn6CY7otwZ+cV/ZHPiJJYFzH7
         Hx3A/wcLgU793P6OqqKSqWvQOuNzbB5GP9xxL6hr4yqjXLRNiuT4Xai/uqyuVznGE3Hp
         qyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7In0GU6wcgBJO6cgejycIAA7qvLikGPOVN/ipT1rQI=;
        b=wP10twNO6wcNigdrcVKJAJ8bIRTlto9+IovpbAWErHe+7V6BbTuNQ2ujYcUxdiuqnf
         +d6DDo6Z3mls7qTm6W6i/gJDMdrPSnJ8EIdxpQrvbW8nXeLYb2jNvICg/T0PhB0LZ/Rx
         3UN83lone7XCdrUVmI5x9PFFCg3vbA8Uku8isXLYcjXGOl8uP+NrSans+Zlg5KaGzVNy
         S5D/L8ctw8itLMn0PBCIEomqKFvdyVzZMN3ZvP4AXYuN3eLT1MDbJefQlbX6hWN2EtpV
         5xpNdrUOXdDvj2IUjfI0ssLIV0udrVaCWPYJcNIUbwG49OSAu807Q3WC5GdXLmE0Y+QR
         SQLA==
X-Gm-Message-State: AOAM533c4j+0VRMVxxssxmGkToGFNYnMGd8gwE3tuUwXKXF7r2dKjbah
        GGuTbFgPDjVmdpfU+ZkhO27vy+jpGeC/aA==
X-Google-Smtp-Source: ABdhPJwzSWcT4QR/Jf5Ijs5VKG8K+1psVxnp1DU17XcLANQQLeH8gup7y6UUMEomm5NlLR7W38RXgQ==
X-Received: by 2002:a62:ce82:0:b0:50d:512f:7b76 with SMTP id y124-20020a62ce82000000b0050d512f7b76mr26218087pfg.79.1652284582479;
        Wed, 11 May 2022 08:56:22 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id g3-20020a631103000000b003c265b7d4f6sm44644pgl.44.2022.05.11.08.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:56:22 -0700 (PDT)
Date:   Wed, 11 May 2022 08:56:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Magesh  M P" <magesh@digitizethings.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: gateway field missing in netlink message
Message-ID: <20220511085619.4b549ee1@hermes.local>
In-Reply-To: <DM5PR20MB2055B826355ED50BFCF602C8AEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504223100.GA2968@u2004-local>
        <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504204908.025d798c@hermes.local>
        <DM5PR20MB20556090A88575E4F55F1EDAAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <DM5PR20MB2055F01D55F6F7307B50182EAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220505092851.79d3375a@hermes.local>
        <DM5PR20MB2055542FB35F8CA770178F9AAEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220509080511.1893a939@hermes.local>
        <DM5PR20MB2055EBCA16DFB527A7E9A32FAEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
        <DM5PR20MB2055B826355ED50BFCF602C8AEC89@DM5PR20MB2055.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 05:35:21 +0000
"Magesh  M P" <magesh@digitizethings.com> wrote:

> =C2=A0
> Hi Steve/Dave
> =C2=A0
> Could you please confirm that VPP during synchronization of routing table=
 with Linux kernel in case of dual gateway ECMP configuration gets only sin=
gle route in the netlink message is a known bug ??=20
> =C2=A0
> I am using VPP 21.06 version.
> =C2=A0
> Regards
> Magesh=20
> =C2=A0

I don't work on VPP.

There is no kernel bug here.
