Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DED58E23E
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiHIV66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiHIV6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:58:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC316BD78
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 14:58:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b4so12959277pji.4
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 14:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/iud5449VkbBRpl17un0ZNxgI4YCaJVJAcbRLkgThmY=;
        b=R1kcLY7pLIEraGoHirN2EH7BUMGNG/4Pxt4p2PpOt0xDTZwxTkwfTE88hZisb8OXix
         a6w3cp+jkEmKu5E2HnFr6PopBFO24fzYKxdRfQaJeUnzPdDGpE/sOhrRoiBoErZIZWy8
         PwgETxQ71P7/eRcpvxzOevWqMHf78UDZbrJQ1rcX3+Th/Jwkr+FVu2IyZovQRadbaMNm
         VThk6v8WGBv6qDfx4XfvTTRFD050HJXR4l+afxmYh7NfyU3KlcGS/HAeNuJ4sit1cv92
         FlYXygCY6oPkmu/bqgCehOlzgycecqv4hsVcq67i88ShBXmf2/ZpdQf7W7sbon/uwbJV
         lJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/iud5449VkbBRpl17un0ZNxgI4YCaJVJAcbRLkgThmY=;
        b=lynXfuBhb8oDb2/1TcY7thVT5yVo9iwQTp1dYNS1xQ1vHaUs8IpHWezUIvNeSzu1m/
         Yiq02pdTmLda4kcc+NRh+uNy/Fg9pSl0aZ6symQ7PQumPiDuJ4gdB5wrohSGQrXdYx1X
         WPcYKZnD36AU1OC8xQReq27MPz8gxjMB8uWU7a+7uN18Q4bLhV/Oqx/OnZ03JWFPqZaW
         ihaJ2YPyZ6StUHza0ljw+VqD0XTJLMXHUJmFca8SCoqMNf51GSkxcJNXUvKcrXBKudfu
         ksW5vpox+IePuoeVgNm6e7Dkgp2CRdHZ06a7H9sz2bV46eGZXe4agWz1kuBUOZwhO0R4
         BtkA==
X-Gm-Message-State: ACgBeo3eFV07FkdNtKa/ZeFy42mZXOKXsdftOLG7OPRk6AlQi6EmxPgz
        y1QRZpStBNs2idk7l9Ih6z2Ecw==
X-Google-Smtp-Source: AA6agR6LcYahmAuy1Ii+x9X25mfI3ypAunHZNUzCjdzor6vmBpDOZaB86eM63VC+JPZs7FE8JLehfA==
X-Received: by 2002:a17:90b:1b45:b0:1f3:1974:eb8 with SMTP id nv5-20020a17090b1b4500b001f319740eb8mr502721pjb.200.1660082327051;
        Tue, 09 Aug 2022 14:58:47 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id gn19-20020a17090ac79300b001f303d149casm64808pjb.50.2022.08.09.14.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 14:58:46 -0700 (PDT)
Date:   Tue, 9 Aug 2022 14:58:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220809145844.3048fa9c@hermes.local>
In-Reply-To: <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
        <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
        <20220808210945.GP17705@kitsune.suse.cz>
        <20220808143835.41b38971@hermes.local>
        <20220808214522.GQ17705@kitsune.suse.cz>
        <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
        <20220809213146.m6a3kfex673pjtgq@pali>
        <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Aug 2022 14:39:05 -0700
Tim Harvey <tharvey@gateworks.com> wrote:

> > Maybe it would be better first to use "label" and then use ethernet alias?  
> 
> I've been wondering the same as well which made me wonder what the
> history of the 'aliases' node is and why its not used in most cases in
> Linux. I know for the SOC's I work with we've always defined aliases
> for ethernet<n>, gpio<n>, serial<n>, spi<n>, i2c<n>, mmc<n> etc. Where
> did this practice come from and why are we putting that in Linux dts
> files it if it's not used by Linux?
> 
> Best Regards,
> 
> Tim

I added ifalias as part of better SNMP support.
In telco and router equipment they report the type/topology information
as ifAlias in MIB.

In Vyatta distribution this was set to information that came from
the pci subsystem for typical network PCI devices.

Recent distributions added altname support to allow for alternative
or longer names.
