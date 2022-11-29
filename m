Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05A863BBDF
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiK2InP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiK2InM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:43:12 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED722DED7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:43:10 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so13751002wma.1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=deriGvzaVwpiPYcwlKQQ/tYN874dqD9ot+W/jy6OMWI=;
        b=WJRJ/wUIlzSDSUpraVnawH+Pl2jh9le9tDsOkQpuhnZXrzFF/49QTPgkV4fWGVSJEd
         YA7l70K3+CBN4PM1CH9GVNoq+AN44cIF3TAU6WRHXKtGl72gtwVZRQEwHppbde+gSqxK
         bxPGun8RAA86WwWRXgROezlO9JXeUH/R+qOT8HSVu+i7fXsPMNOvXYkdADZHT70y17wb
         zMcGv5faPbol5vat6BpvPkFf8uphBtR08+VREoUDGlSKljzwAHPq6q+WqM+hlQ7lIkqk
         n7aIUZ156ycqWf0RvSFfNJdMP0K4nPOUCt4tEABIwktxvoS8tE6BUK6HGOLUpzbr/mdl
         LF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=deriGvzaVwpiPYcwlKQQ/tYN874dqD9ot+W/jy6OMWI=;
        b=Ugy5rj1kuFg1u04H9Q5aY34TDQd0qeJrjIdROERssjKdc7+uNcgav6ntAV2ffBBBrL
         k97+fE5hUVgBD09PbRWG6PiI3m0DbYEHKrQT71u+Aeuvn6T4TxugOUfBVw6PXnv1bcUk
         WmfmNcWBI/pnG2YHShnk+CzWtLgiafy2k0cBVuF09r+mIcV5U2dc0bryMXsou73yVqWf
         7wZef9AuFsWBp4IsInnkjNlbWUORP0eKAsbiNKX3ndmOwGY6lwUmed/wsDjVdUq8R8iK
         RwrqkvrZ6C75e1MQp98jbXnkLQxqkpa3dj7A6mPLTLlTKAY3LeSIaN3dYRVR9p9GjvDz
         jyOg==
X-Gm-Message-State: ANoB5pkojgxQCQw5rMo+DNDeD19ul08RjusUycyEtPQEw0k6i/n7nCzb
        X32nBobvPIQpho8Ii2HZPl8=
X-Google-Smtp-Source: AA0mqf6ISuIeeAEnxPkLnNL+4U1TOhZDOEiQOeLUjYuN6WuJfuSJat5+1suVTmKL4DTJ0B+Oi5GIXg==
X-Received: by 2002:a05:600c:540a:b0:3d0:50c4:432c with SMTP id he10-20020a05600c540a00b003d050c4432cmr10587222wmb.67.1669711389189;
        Tue, 29 Nov 2022 00:43:09 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id h130-20020a1c2188000000b003b4fdbb6319sm1256025wmh.21.2022.11.29.00.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 00:43:08 -0800 (PST)
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
To:     Marcelo Leitner <mleitner@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <156aaabc-a7f6-e7e6-eb0b-d8943f212c1f@gmail.com>
Date:   Tue, 29 Nov 2022 08:43:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/11/2022 13:11, Marcelo Leitner wrote:
> Exactly. Then, when this patchset (or similar) come up, it won't
> update all actions with the same stats anymore. It will require a set
> of stats from hw for the gact with PIPE action here. But if drivers
> are ignoring this action, they can't have specific stats for it. Or am
> I missing something?
> 
> So it is better for the drivers to reject the whole flow instead of
> simply ignoring it, and let vswitchd probe if it should or should not
> use this action.

I agree.  Drivers should only accept a flow with a 'gact pipe' action
 if they are able to perform the stats offload it requests.
Getting userland to autodiscover whether it can make use of this is a
 SMOP, better than having it always try to use it and then sometimes
 get confused that the resulting stats are wrong or meaningless.

-ed
