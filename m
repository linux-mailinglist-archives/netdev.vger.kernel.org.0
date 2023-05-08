Return-Path: <netdev+bounces-865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AA36FB094
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97BB8280F74
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4A564C;
	Mon,  8 May 2023 12:48:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97FD193
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:48:46 +0000 (UTC)
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B9035559
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:48:45 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-61a9bb1b3a0so21701606d6.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 05:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683550124; x=1686142124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XyjfhCZUD5eYHjPgm/g8j7Q6pTyEuAMpCYs7lxWxReo=;
        b=CFw+cg+PTr0ViHvAq9mW1a4d8s4/yf306h0sAYnD8xqsf8rsd5MoMJpVCk7dIBHjO/
         jcTLC7vg3XEQPlpC5e5LunMAzl4x9qH0sBqPq+Nz6MkRDRM6sauhof/28ULryPPAZWMx
         VTNO/QR+EhNVAc783iM+ih/FTbR6cwzWDPPKpADU7ESEcn7KU5iP2bfX29M55oOZTY3M
         HZUPCuP+0z0ErtyQCPf4lBYFO7rHO6UuCQs2OvovlLsiEsDga+q1ZtLd2T8gYn3pNZ+f
         okc9n1kP7+ZakIoMwM1Lm+X9toD0xGgMMz5V3hm9KXoZaV2my57DaFRJCakWkGccEinq
         UiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683550124; x=1686142124;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyjfhCZUD5eYHjPgm/g8j7Q6pTyEuAMpCYs7lxWxReo=;
        b=RNmj007fX2akfJ3GouKClnkTrDLTv8wnv/W14oOdMh4Tp9XAUnAft5R4Xr+Kgx42U1
         bsrjnylXyDq4jOPw6oy5yuEaAJGTRcEsyicBNI670hM392GWT+oY4B4Y1tbsd5mF95OB
         MSHcNumWJE92M17NJVxPzmUrW8ohRxe1iKc6G/AiFY3Y2y3EZhLJhk6hRUXY4NAgjP+r
         /XMQRPzunpnBHHNvE3e+YqU5mJV9m3SH0Yuj9IWEeFre/N3KIMhSyU7EhpV5B3YnoEV+
         3QnHdsMKJF5adssAUrnY07XUbVWsrLyV3NOUbca4i/V6oWIzMoVDw4RTtFDxg4XA+c6u
         zqjA==
X-Gm-Message-State: AC+VfDwd6RZ0k7O2dZejauhDtkukEixZLnQ4u3JAxYYlauRr8050QVqf
	4C65UxefCKmtVXz95+82CHNBPQF0DgE=
X-Google-Smtp-Source: ACHHUZ6txNIWwq3indX/zZD8u6Et6EUtBI8dZhdPFRnlH8Cs26l7D99YU/C5/N8r5VRdvx1mCziusw==
X-Received: by 2002:ad4:5cce:0:b0:5ef:8c35:296c with SMTP id iu14-20020ad45cce000000b005ef8c35296cmr13206596qvb.44.1683550124354;
        Mon, 08 May 2023 05:48:44 -0700 (PDT)
Received: from ?IPV6:2602:47:d92c:4400:3754:1f3a:8fb6:2341? ([2602:47:d92c:4400:3754:1f3a:8fb6:2341])
        by smtp.gmail.com with ESMTPSA id w3-20020a0cdf83000000b0061d92e1877bsm2691770qvl.124.2023.05.08.05.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 05:48:43 -0700 (PDT)
Message-ID: <805b69fb-9852-b209-3b45-680b60e3eb37@gmail.com>
Date: Mon, 8 May 2023 08:48:43 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH ethtool 3/3] Fix potentinal null-pointer derference
 issues.
To: Michal Kubecek <mkubecek@suse.cz>
Cc: netdev@vger.kernel.org
References: <cover.1682894692.git.nvinson234@gmail.com>
 <105e614b4c8ab46aa6b70c75111848d8e57aff0c.1682894692.git.nvinson234@gmail.com>
 <20230507225752.fhsf7hunv6kqsten@lion.mk-sys.cz>
 <8907c066-9ac9-8abc-eeff-078d0b0219de@gmail.com>
 <20230508074039.n6ofud6dbkuhe64x@lion.mk-sys.cz>
Content-Language: en-US
From: Nicholas Vinson <nvinson234@gmail.com>
In-Reply-To: <20230508074039.n6ofud6dbkuhe64x@lion.mk-sys.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/8/23 03:40, Michal Kubecek wrote:
> On Sun, May 07, 2023 at 10:46:05PM -0400, Nicholas Vinson wrote:
>> On 5/7/23 18:57, Michal Kubecek wrote:
>>> On Sun, Apr 30, 2023 at 06:50:52PM -0400, Nicholas Vinson wrote:
>>>> Found via gcc -fanalyzer. Analyzer claims that it's possible certain
>>>> functions may receive a NULL pointer when handling CLI arguments. Adding
>>>> NULL pointer checks to correct the issues.
>>>>
>>>> Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
>>> A similar theoretical issue was discussed recently:
>>>
>>>     https://patchwork.kernel.org/project/netdevbpf/patch/20221208011122.2343363-8-jesse.brandeburg@intel.com/
>>>
>>> My position is still the same: argv[] members cannot be actually null
>>> unless there is a serious kernel bug (see the link above for an
>>> explanation). I'm not opposed to doing a sanity check just in case but
>>> if we do, I believe we should check the whole argv[] array right at the
>>> beginning and be done with it rather than add specific checks to random
>>> places inside parser code.
>> By convention and POSIX standard, the last argv[] member is always set to
>> NULL and is accessed from main(int argc, char **argp) via argp[argc] (see
>> https://pubs.opengroup.org/onlinepubs/9699919799/functions/execve.html).
>> It's also possible for argc to be zero. In such a case, find_option(NULL)
>> would get called.
> Please note that ethtool is not a utility for a general POSIX system.
> It is a very specific utility which works and makes sense only on Linux.
> That's why it can and does take many assumptions which are only
> guaranteed on Linux but may not be true on other POSIX systems.
>
>> However, after reviewing main(), I recommend changing:
>>
>>          if (argc == 0)
>>
>>                  exit_bad_args();
>>
>> to
>>
>>          if (argc <= 0 || !*argp)
>>
>>                  exit_bad_args();
>>
>>
>> as this fixes the potential issue of main()'s argc being 0 (argc would be -1
>> at this point in such cases), and "!*argp" silences gcc's built-in analyzer
>> (and should silence all other SA with respect to the reported issue) as the
>> SA doesn't recognize that it would take a buggy execve implementation to
>> allow argp to be NULL at this point ).
>>
>> If you don't have any objections to this change, I can draft an updated
>> patch to make this change.
> As I said before, I do not object to adding a sanity check of argc/argv,
> I only objected to adding random checks inside the parser code just to
> make static checkers happy. If you want to add (or strengthen) a sanity
> check right at the beginning of the program, before any parsing, I have
> no problem with that.

I am abandoning this patch in favor of a new one with the subject line 
"[PATCH ethtool] Fix argc and argp handling issues".

Thanks,

Nicholas Vinson


> Michal

