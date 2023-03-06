Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDDF6AB831
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 09:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCFIZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 03:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCFIZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 03:25:14 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFD01E1F5
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 00:25:11 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id u9so35116550edd.2
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 00:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678091110;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3C0OYWEmZtT477Pr3OwsU2N9s5Y46TAXu6D6u8yRBYU=;
        b=TryqF8oAkx44cIzU/5FVc5vGMjXWgblLMCqZ9hhWIyG6CJ/RMYvJyX0cYy6pipE9AJ
         m1DlQafQteokSTRNdocwgQ7G70PkOgGNxwSklHNtRHUxNYEh9l3N0sN8DwrqlxLsbjNx
         jR9qYh+QE3s4Z9kEqmH+GzRty5DTdrkbJvl7LzDmAC9V3LLQdJeYVdJ5/a2+bB+YzEve
         b39JvkcnLcZaQhYoRoafrEV2suHAtHcRcqfgBDtLt42miYAMdtk9WW/vCCjz59cBLCp5
         EfhjYMnZA6+YeSduXmVGKEjMw6QHKlIzWIua6E0QvGQVmhvwnCAj3/se6cFB/JmNIRCG
         4uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678091110;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3C0OYWEmZtT477Pr3OwsU2N9s5Y46TAXu6D6u8yRBYU=;
        b=aGHkYCG/YH0T7JjQsDmnMmxTT04gvRRzREtotrmaeBFqishx3noZYMp0CSUBnw43nz
         TVqDG7OoZqqp+UB/fCuXC3W4QKUukcXnE3EEbBoss3oflU00E5w/sfxdfiHcn6QFLekE
         WC6Cb37jgqssR68eNxJHUggx/c7m7u8+N2CfTBKAP5FEX/y9F2ZzGGc4fX4aZf+18kg4
         aHdHgfG4i58i8sLDLS/XSbrwPoir3sT6pK3NSPvQacGMsjj5HY9+czUKgNQEiQmAufb8
         r8dxUuYyfvKTLvXjVr8RW8zEh3xr2hDDXvC5jOzrA7CnJOT2n9LUu1RANaWwPln/ebHh
         SYBA==
X-Gm-Message-State: AO0yUKUL/rcqM32wh2OB+aInlc2d74P1BWVEVt8GZSGgH+uHEX/Z9jIa
        eDcEJ6XNXtKzSZrLgEZydi/asQ==
X-Google-Smtp-Source: AK7set8Q0SKIVyBR+7bdv9T4+BHgRwuz6Wzfr5pf6EZtrHGuOj0/asa/sLuyTQh4nEL5PBl6cNOeqQ==
X-Received: by 2002:a17:906:1557:b0:8af:22b4:99d2 with SMTP id c23-20020a170906155700b008af22b499d2mr13831051ejd.5.1678091110158;
        Mon, 06 Mar 2023 00:25:10 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r16-20020a170906a21000b008cafeec917dsm4236805ejy.101.2023.03.06.00.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 00:25:09 -0800 (PST)
Date:   Mon, 6 Mar 2023 09:25:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: devink dpipe implementation
Message-ID: <ZAWjZJ19I/I3N1jk@nanopsycho>
References: <DM6PR12MB42021C6149409933958BE777C1AF9@DM6PR12MB4202.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM6PR12MB42021C6149409933958BE777C1AF9@DM6PR12MB4202.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 27, 2023 at 01:05:14PM CET, alejandro.lucero-palau@amd.com wrote:
>Hi,
>
>I'm looking at the devlink dpipe functionality for considering using it 
>with AMD ef100.

What is your goal?


>
>There is just one driver using it, Mellanox spectrum switch, as a 
>reference apart from the devlink core code.
>
>I wonder if due to this limited usage the implementation is not covering 
>other needs or maybe I'm missing something.
>
>For example:
>
>enum devlink_dpipe_match_type {
>     DEVLINK_DPIPE_MATCH_TYPE_FIELD_EXACT,
>};
>
>It seems obvious other matches should be supported, at least for 
>supporting matching based on masks. Is this because spectrum switch does 
>only have BCAMs?

dpipe exposes ASIC pipeline to the user to provide visibility. In case
of mlxsw, there are only some fragments exposed. There the exact match
is enough.


>
>
>Other examples:
>
>enum devlink_dpipe_field_ethernet_id {
>     DEVLINK_DPIPE_FIELD_ETHERNET_DST_MAC,
>};
>
>enum devlink_dpipe_field_ipv4_id {
>     DEVLINK_DPIPE_FIELD_IPV4_DST_IP,
>};
>
>Again, I guess other fields should be support.
>
>If this is because only that needed by the only driver using it was 
>added, I guess using dpipe for ef100 would need to add more support to 
>the devlink dpipe core.

Sure.


>
>Can someone clarify this to me?
>
>Thanks.
>
