Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C994DE1AF
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiCRTV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240331AbiCRTVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:21:55 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD592EDC25
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:20:36 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p15so4862085lfk.8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Da58XaamdPOR/ut8eZdkl+mrEW3bShbo5Rc5hbiuMTM=;
        b=w3A1gmFvMBRV3VcP/tlmmxK7SilLiBhMJY7WX6sR0dQPXbJyHi2G3x8KvjDqadbTeM
         pDC4QBTprn67FUQAukRopeIB/t/3tOqqaD4o0O9jqZoIUQp27KTMVGZpB3yAXwsn5ngE
         Bnv+gkpdhpG3aROoWmZVzvauuqQb0XIkc+X8d6zREBy65qbG4SekhSisr067zD3zzxje
         k1FgYHpERi61ysgFAE/jF5nwIXaJ0pvF8Zvj7pOP/DpvxXkG/uqJCt0ATcD0vmO6h90w
         eEkCq/H1n/YorE+CgGemeczBw6KMnDF5FlEgELxYdGIwSMDZ3HE6W9QCUdZiSfUnw0CH
         C+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Da58XaamdPOR/ut8eZdkl+mrEW3bShbo5Rc5hbiuMTM=;
        b=Xe1QGeLlHmNBefGinTWG3HYDnMcbA2paGUCSX4RoKsW58rNoE78PKn2VsvbWrrvjiD
         NPigq3wYwJENDREvhpPWY+Mq2igAUWtIWdF0TWKbMhjuVN5qqtJeXxkFsEg60De/ifE6
         hyQ9fOF7DGF7Rizir4H/KKBJ4qazHVd9aUXtrkRt8o8x3A03JlsJ+I9mguyiv2U1Cni2
         qLXpLLVtoBDNvBzPuL0XWOVaCFxBisRXZwtaoqkUzAjS0J47ChShHuYkk4rf9U0hMGxR
         oCJzHkzeCnJhsQN17f5ZjvMSpZBQc3mFJZOfmMO74HvjgZo7l3rQy7Rw2HyeztLf/PUy
         10BA==
X-Gm-Message-State: AOAM530IoQIn0T5lg6FmIA++5Hj3mvIYiIVXP5EmW1a02nHCwbwTmBbb
        1Q757U6HD3mLXPl1T7LfHc1lAQR6CliY2skX
X-Google-Smtp-Source: ABdhPJyFO7/fz3qPOxGG1FljVa+GCYdqUk/XsNQFolR0haSMWpOejHbzuD2hZpyE4qLFsulQq7XQFw==
X-Received: by 2002:ac2:57d4:0:b0:448:2cba:6c86 with SMTP id k20-20020ac257d4000000b004482cba6c86mr6599009lfo.201.1647631234624;
        Fri, 18 Mar 2022 12:20:34 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id bq8-20020a056512150800b00448ab58bd53sm971692lfb.40.2022.03.18.12.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 12:20:34 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: mv88e6xxx broken on 6176 with "Disentangle STU from VTU"
In-Reply-To: <20220318182817.5ade8ecd@dellmb>
References: <20220318182817.5ade8ecd@dellmb>
Date:   Fri, 18 Mar 2022 20:20:33 +0100
Message-ID: <87a6dnjce6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 18:28, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> Hello Tobias,
>
> mv88e6xxx fails to probe in net-next on Turris Omnia, bisect leads to
> commit
>   49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")

Oh wow, really sorry about that! I have it reproduced, and I understand
the issue.

> Trace:
>   mv88e6xxx_setup
>     mv88e6xxx_setup_port
>       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_STANDALONE) OK
>       mv88e6xxx_port_vlan_join(MV88E6XXX_VID_BRIDGED) -EOPNOTSUPP
>

Thanks, that make it easy to find. There is a mismatch between what the
family-info struct says and what the chip-specific ops struct supports.

I'll try to send a fix ASAP.
