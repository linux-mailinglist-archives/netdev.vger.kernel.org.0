Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9994D0663
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244764AbiCGSWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbiCGSWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:22:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EE108300D
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646677308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pL8XlxrcxydHnx0lCXQyvTaEWxtKk5DHpBUj+AR+U20=;
        b=TABP+o4zaDNInEWApMlXo/cgmWPL01PjHjKAifDPQjM/4EGBZnvxEx4cba4qPlpNxdEmfz
        P4Fic3Cy/C7E4sxGl8Hc/7wjgnqFA8mAQWxFUOr8DFNTpCVpp6i7xT5Z3I/2lBjx/yqVUj
        kd9OQ3Z6CK3uFIjCJz5L2Und34oQ5W4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-f97XbzhYMq2gzbUZjNOTWw-1; Mon, 07 Mar 2022 13:21:47 -0500
X-MC-Unique: f97XbzhYMq2gzbUZjNOTWw-1
Received: by mail-ej1-f69.google.com with SMTP id y5-20020a1709060a8500b006da9258a34cso5606417ejf.21
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 10:21:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pL8XlxrcxydHnx0lCXQyvTaEWxtKk5DHpBUj+AR+U20=;
        b=ua7fqN7X8L5Kw7FgIB3ynXxPkZDh8ZMFYcpYbjlRfbZim9AEKRhOv/pCVVrB6Zsbc8
         vo5UjOO/kS3O8bOfuhlCG9x6Zt+p0Rb3NJpF5quwdJxPb1ZIHbmxUdhj2KCbv0+nFwSu
         8rAEhaFhYRjt/xrgAaj4gn1pb1VBdGefVMNks6E4oD3Bf01zgDenxiIZGG6LHbS31lnc
         WkvKEnp5Ehsh7ObF1vIBZrmgHQdH+Qb8eGzm0H9x9lgWI8D8x95z9nv8jB1z0VrB3G5R
         S5IGLJzJLqJy/3jsEZCzoV1eLq1T+TAaxMjPwdM0Vux2qdGo0EI1pAcd2RfIMf61KHYD
         Uoew==
X-Gm-Message-State: AOAM532MIpcOkY5kbaTS1NK1dt6UEdXMH19Iif7v0C1pk8PM3anORGo2
        yQp00s7YTP+Bpm9LWRbjAQd0TWjjv8BgBm5xuanXVOqeAx8vsvWCsijrqOB3m5MQPE3QSkMBT5k
        1PCmubJKQyP3nqZqt
X-Received: by 2002:aa7:d991:0:b0:416:5f6c:e260 with SMTP id u17-20020aa7d991000000b004165f6ce260mr2735719eds.268.1646677306111;
        Mon, 07 Mar 2022 10:21:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0gZZNBeD3BhC5uDKmfAR4j/QKhQu6eO/t5vu1NI3OLxg1yX2k/X6ET8DFKUZyiqqrj+fY6g==
X-Received: by 2002:aa7:d991:0:b0:416:5f6c:e260 with SMTP id u17-20020aa7d991000000b004165f6ce260mr2735701eds.268.1646677305912;
        Mon, 07 Mar 2022 10:21:45 -0800 (PST)
Received: from localhost (net-37-119-159-68.cust.vodafonedsl.it. [37.119.159.68])
        by smtp.gmail.com with ESMTPSA id k20-20020a170906681400b006da86bef01fsm5025136ejr.79.2022.03.07.10.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 10:21:45 -0800 (PST)
Date:   Mon, 7 Mar 2022 19:21:41 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Message-ID: <YiZNNQB727Il+EVN@tc2>
References: <cover.1646223467.git.aclaudi@redhat.com>
 <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
 <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527dab8b-6eba-da17-8cef-2614042c9688@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 10:58:37AM -0700, David Ahern wrote:
> On 3/2/22 5:28 AM, Andrea Claudi wrote:
> > diff --git a/include/utils.h b/include/utils.h
> > index b6c468e9..81294488 100644
> > --- a/include/utils.h
> > +++ b/include/utils.h
> > @@ -307,7 +307,7 @@ char *find_cgroup2_mount(bool do_mount);
> >  __u64 get_cgroup2_id(const char *path);
> >  char *get_cgroup2_path(__u64 id, bool full);
> >  int get_command_name(const char *pid, char *comm, size_t len);
> > -char *get_task_name(pid_t pid);
> > +int get_task_name(pid_t pid, char *name);
> >  
> 
> changing to an API with an assumed length is not better than the current
> situation. Why not just fixup the callers as needed to free the allocation?
>

I actually did that on v1. After Stephen's comment about asprintf(), I
got the idea to make get_task_name() similar to get_command_name() and
a bit more "user-friendly", so that callers do not need a free().

If you think this is not ideal, I can post a v3 with the necessary fixes
to the callers.

Thanks,
Andrea

