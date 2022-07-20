Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB6957B902
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbiGTO6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237462AbiGTO56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:57:58 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61314AD47
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:57:56 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id p132so11143275oif.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XSU2WUPOvF0fUCTGSGRZkl8WCZhfSChGKTGTEOsuYNI=;
        b=iGIpbP2d3UEwVFWw5G9dZlMqJx4o8UCPvRj6piZLN7Qixwv38zIteUBoiwtf11TzoJ
         8pcI1FzJmEI8s8Z8r4wNd/P56A7AMD40p0ifu6Z8wqaycmhnxl9M7kNdXzB8SXogNKD/
         YVqd80JtH2cgsBKx3SUf9wdgi1qit4j7Py/II=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XSU2WUPOvF0fUCTGSGRZkl8WCZhfSChGKTGTEOsuYNI=;
        b=j4/w5olrx4e7wFpPwaNW2D4g22R+YOj3gpuOa/chvDO2Xa1DzqzXq6gmOo9ndikAKj
         0IPmhGcaaOH4SL+GM9UJGlyycTDTmi4J17bxU7GGtH50WVcFwHa8IRSVInH4CfyxHOQh
         YfbgmfzahsbLeQGJgiAZ4PZnEVFG8JomSJ8fzKxkPAzmRGTu2CTJTTHuAh4tYDiis6iC
         hrVczoPesbQjk4BvKGxrwRnON3D6K5j85cHcucvM6ntAQepE7VeObs7Qj0sLnN4A9+Xk
         KCgHO2ZBPTNWMgkCC6DA2r39V+YEz2+yce7H6OFvXEcbqgTEFkRTELvjWrnJMGOdAxAm
         g+nA==
X-Gm-Message-State: AJIora9dTsFvO55J3MYlJaAqs54S6MUlEdfR1JoUXYUg3d2gfJgki877
        AzxwGWtivE7Tre9tOjNPivS8+w==
X-Google-Smtp-Source: AGRyM1v5UNxUPAVexBnv65PVVqbWvE8t6MWf9AqqczcauOBSa7XBiaehpgEh3k3h5n6IkYivB27NLA==
X-Received: by 2002:a05:6808:170c:b0:335:1d14:f99d with SMTP id bc12-20020a056808170c00b003351d14f99dmr2435919oib.243.1658329076048;
        Wed, 20 Jul 2022 07:57:56 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id z14-20020a9d62ce000000b0061c7a5691f2sm7425058otk.47.2022.07.20.07.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 07:57:55 -0700 (PDT)
Message-ID: <42069251-3ea7-b0c7-4efb-e144c52ebf51@cloudflare.com>
Date:   Wed, 20 Jul 2022 09:57:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 4/4] selinux: Implement create_user_ns hook
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20220707223228.1940249-1-fred@cloudflare.com>
 <20220707223228.1940249-5-fred@cloudflare.com>
 <CAHC9VhTkvPvqGQjyEKbi2pkKBtRQE=Uat34aoKsxjWU0qkF6CA@mail.gmail.com>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <CAHC9VhTkvPvqGQjyEKbi2pkKBtRQE=Uat34aoKsxjWU0qkF6CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/22 8:32 PM, Paul Moore wrote:
> On Thu, Jul 7, 2022 at 6:32 PM Frederick Lawler <fred@cloudflare.com> wrote:
>>
>> Unprivileged user namespace creation is an intended feature to enable
>> sandboxing, however this feature is often used to as an initial step to
>> perform a privilege escalation attack.
>>
>> This patch implements a new namespace { userns_create } access control
>> permission to restrict which domains allow or deny user namespace
>> creation. This is necessary for system administrators to quickly protect
>> their systems while waiting for vulnerability patches to be applied.
>>
>> This permission can be used in the following way:
>>
>>          allow domA_t domB_t : namespace { userns_create };
>>
>> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
>>
>> ---
>> Changes since v1:
>> - Introduce this patch
>> ---
>>   security/selinux/hooks.c            | 9 +++++++++
>>   security/selinux/include/classmap.h | 2 ++
>>   2 files changed, 11 insertions(+)
>>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index beceb89f68d9..73fbcb434fe0 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -4227,6 +4227,14 @@ static void selinux_task_to_inode(struct task_struct *p,
>>          spin_unlock(&isec->lock);
>>   }
>>
>> +static int selinux_userns_create(const struct cred *cred)
>> +{
>> +       u32 sid = current_sid();
>> +
>> +       return avc_has_perm(&selinux_state, sid, sid, SECCLASS_NAMESPACE,
>> +                                               NAMESPACE__USERNS_CREATE, NULL);
>> +}
> 
> As we continue to discuss this, I'm beginning to think that having a
> dedicated object class for the userns might be a good idea.  I believe
> I was the one who gave you these code snippets, so feel free to blame
> me for the respin ;)
> 

No worries, I'll make this change for v3.

> This is what I'm thinking:
> 
>    static int selinux_userns_create(const struct cred *cred)
>    {
>      u32 sid = current_sid();
> 
>      return avc_has_perm(&selinux_state, sid, sid,
>                          SECCLASS_USER_NAMESPACE,
>                          USER_NAMESPACE__CREATE, NULL);
>    }
> 
>> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
>> index ff757ae5f253..9943e85c6b3e 100644
>> --- a/security/selinux/include/classmap.h
>> +++ b/security/selinux/include/classmap.h
>> @@ -254,6 +254,8 @@ const struct security_class_mapping secclass_map[] = {
>>            { COMMON_FILE_PERMS, NULL } },
>>          { "io_uring",
>>            { "override_creds", "sqpoll", NULL } },
>> +       { "namespace",
>> +         { "userns_create", NULL } },
> 
> The above would need to change to:
> 
>    { "user_namespace",
>      { "create", NULL } }
> 

