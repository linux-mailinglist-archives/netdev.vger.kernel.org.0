Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F86C49BB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCVLzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjCVLzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:55:42 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05364FCFB
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:40 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id q88so5683361qvq.13
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679486139;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ns3vKihYI7PBl7IvZvD26J6UpwLPf/f1vo6WmaC9A9o=;
        b=nYghucJpy7dgQ4zFotPkjrtPNOxJbB9FpqFK5HwtSPbvTCCghODYIxbX5svqWjuXZ0
         A9gfDp7eRLnYBKR4AY335DwFn7LPCNQYQc34GEW1ggXIH550asYzadT5Si6V//CGDi+2
         93EWIxWqBAUzZQ9n/5iXzZHKNp9uhp57iZs95V7g/9tvFG0VjGtfCP6SEjUC3Zx22WlP
         jIXsZnMOPTTbzxR5pKbfWWezbhqFcHfMqIVnP9YRaF2s7HZuI8PbRAN+0Tj/iWj+QSwT
         ISAN7BO7gpUWkay8JATGZRD1qKYR7uvO+vI/5OoOl81vjDeEijs8U0FZPJoxai0Pp/9S
         WYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679486139;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ns3vKihYI7PBl7IvZvD26J6UpwLPf/f1vo6WmaC9A9o=;
        b=2wbSyM707kDgez54SkB5ngD9RmGv+UEYAwPg1Y+sjKqDTp3xE6uZI3lxGxDFjieOYg
         u5TQDtjnScb3zBhyDUXFRidz/wTkBV+rswLOfBHMzLG1QQF9dX9NolXgU3gTpPtkYhw7
         ZR9KWr71aILB+ZeAvfbe0++Cw7fW3IYNrsf2avjWoRX75aQv7Blm5p54R6M41y8B6P+b
         1peaXKX3zGLfMjmUIPGLJ+DA9O5hLWCWOrUVLOGb/i6qnbzQNwQpb7QFTro3TaGcbcZB
         Lgw0j0ea+HKyI9Kh/5uSGCgPSN0b5d9GQZG9H0YtxB5n741LB4vwmYLL2MaI67wnVoWv
         Y06A==
X-Gm-Message-State: AO0yUKW+FQ+TAjNVTwRheJ8plyuFBD0fER6RuXMgWjDM+UFFCLuqCmdZ
        NQFTiQ60M0ptszSKP+Nthg4=
X-Google-Smtp-Source: AK7set9eHaAFige2uRlVvGbCIAn8XaYZS2nSsuv239+ninbxvDqEMj1qxgseMgqwabDTQghz8YFkkQ==
X-Received: by 2002:ad4:5ca7:0:b0:557:a5c5:7e01 with SMTP id q7-20020ad45ca7000000b00557a5c57e01mr2787953qvh.25.1679486139695;
        Wed, 22 Mar 2023 04:55:39 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id p11-20020a05620a22ab00b0074357fa9e15sm11170352qkh.42.2023.03.22.04.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:55:39 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 5/6] tools: ynl: Add fixed-header support to
 ynl
In-Reply-To: <20230321223440.2bc23eba@kernel.org> (Jakub Kicinski's message of
        "Tue, 21 Mar 2023 22:34:40 -0700")
Date:   Wed, 22 Mar 2023 11:54:56 +0000
Message-ID: <m2355xj90v.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-6-donald.hunter@gmail.com>
        <20230321223440.2bc23eba@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sun, 19 Mar 2023 19:38:02 +0000 Donald Hunter wrote:
>>
>>      def _dictify_ops_directional(self):
>> +        default_fixed_header = self.yaml['operations'].get('fixed-header')
>>          req_val = rsp_val = 1
>>          for elem in self.yaml['operations']['list']:
>>              if 'notify' in elem:
>> @@ -426,7 +430,7 @@ class SpecFamily(SpecElement):
>>              else:
>>                  raise Exception("Can't parse directional ops")
>>  
>> -            op = self.new_operation(elem, req_val, rsp_val)
>> +            op = self.new_operation(elem, req_val, rsp_val, default_fixed_header)
>
> Can we record the "family-default" fixed header in the family and read
> from there rather than passing the arg around?

Yes, will do.

> Also - doc - to be clear - by documentation I mean in the right places
> under Documentation/user-api/netlink/

Ack.
