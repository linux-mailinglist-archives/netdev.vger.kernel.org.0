Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0861ED9FB
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 02:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgFDAXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 20:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgFDAXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 20:23:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9613C03E96D;
        Wed,  3 Jun 2020 17:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=p4pfmg5pDWaQQ9f8eeAUSJtjT7nb1vCQpcqgCRcmEuA=; b=A1FfMfa6p9msvOQAWFm0BKUdv0
        pIaFClYDiuzF+QrlF3eVkvE3wHKtv61RJ1huUeW944ZRG6XNuJTva3xxVI97Z/rMgBjn2mTiL5apU
        vRXMPJJIGCuoHOwL3t3nxAvlzFvdFDRvyVoaVuc9GCipHpoulVEwGRUqTARjoFRnwfZMKfT3m9bSU
        HlAAEbRgSLEweYmfubHfvxGcH9IEfwWsORBnFW6lMWScwLpRolNHNe5zl+4Bl9nPGq7AyINmf0LUh
        btngvOqsjQ5C9Wh23iKwOQtseFliW3neJ01gxcbK0ZJPOxB7ZggZKHy+5EPbrrBKGxC60B/b344y9
        f9lrc1jw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jgdf5-00020p-3b; Thu, 04 Jun 2020 00:23:11 +0000
Subject: Re: [PATCH v3 2/7] documentation for stats_fs
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526110318.69006-3-eesposit@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c9ddaed1-0efc-650b-6a51-ad5fc431af69@infradead.org>
Date:   Wed, 3 Jun 2020 17:23:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526110318.69006-3-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

Here are a few comments for you.


On 5/26/20 4:03 AM, Emanuele Giuseppe Esposito wrote:
> Html docs for a complete documentation of the stats_fs API,
> filesystem and usage.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  Documentation/filesystems/index.rst    |   1 +
>  Documentation/filesystems/stats_fs.rst | 222 +++++++++++++++++++++++++
>  2 files changed, 223 insertions(+)
>  create mode 100644 Documentation/filesystems/stats_fs.rst

> diff --git a/Documentation/filesystems/stats_fs.rst b/Documentation/filesystems/stats_fs.rst
> new file mode 100644
> index 000000000000..292c689ffb98
> --- /dev/null
> +++ b/Documentation/filesystems/stats_fs.rst
> @@ -0,0 +1,222 @@
> +========
> +Stats_FS
> +========
> +
> +Stats_fs is a synthetic ram-based virtual filesystem that takes care of

                           RAM-based

> +gathering and displaying statistics for the Linux kernel subsystems.
> +
> +The motivation for stats_fs comes from the fact that there is no common
> +way for Linux kernel subsystems to expose statistics to userspace shared
> +throughout the Linux kernel; subsystems have to take care of gathering and
> +displaying statistics by themselves, for example in the form of files in
> +debugfs.
> +
> +Allowing each subsystem of the kernel to do so has two disadvantages.
> +First, it will introduce redundant code. Second, debugfs is anyway not the
> +right place for statistics (for example it is affected by lockdown).
> +
> +Stats_fs offers a generic and stable API, allowing any kind of
> +directory/file organization and supporting multiple kind of aggregations

                                                       kinds

> +(not only sum, but also average, max, min and count_zero) and data types
> +(boolean, all unsigned/signed and custom types). The implementation takes
> +care of gathering and displaying information at run time; users only need
> +to specify the values to be included in each source. Optionally, users can
> +also provide a display function for each value, that will take care of
> +displaying the provided value in a custom format.
> +
> +Its main function is to display each statistics as a file in the desired

                                        statistic

> +folder hierarchy defined through the API. Stats_fs files can be read, and
> +possibly cleared if their file mode allows it.
> +
> +Stats_fs is typically mounted with a command like::
> +
> +    mount -t stats_fs stats_fs /sys/kernel/stats_fs
> +
> +(Or an equivalent /etc/fstab line).
> +
> +Stats_fs has two main components: the public API defined by
> +include/linux/stats_fs.h, and the virtual file system in
> +/sys/kernel/stats.
> +
> +The API has two main elements, values and sources. Kernel
> +subsystems will create a source, add child
> +sources/values/aggregates and register it to the root source (that on the
> +virtual fs would be /sys/kernel/stats).
> +
> +The stats_fs API is defined in ``<linux/stats_fs.h>``.
> +
> +    Sources
> +        Sources are created via ``stats_fs_source_create()``, and each
> +        source becomes a directory in the file system. Sources form a
> +        parent-child relationship; root sources are added to the file
> +        system via ``stats_fs_source_register()``. Therefore each Linux
> +        subsystem will add its own entry to the root, filesystem similar

                                                   root filesystem

> +        to what it is done in debugfs. Every other source is added to or
> +        removed from a parent through the
> +        ``stats_fs_source_add_subordinate()`` and
> +        ``stats_fs_source_remove_subordinate()`` APIs. Once a source is
> +        created and added to the tree (via add_subordinate), it will be
> +        used to compute aggregate values in the parent source. A source
> +        can optionally be hidden from the filesystem but still considered
> +        in the aggregation operations if the corresponding flag is set
> +        during initialization.
> +
> +    Values
> +        Values represent quantites that are gathered by the stats_fs user.

                            quantities

> +        Examples of values include the number of vm exits of a given kind,

                                                    VM

> +        the amount of memory used by some data structure, the length of
> +        the longest hash table chain, or anything like that. Values are
> +        defined with the stats_fs_source_add_values function. Each value
> +        is defined by a ``struct stats_fs_value``; the same
> +        ``stats_fs_value`` can be added to many different sources. A value
> +        can be considered "simple" if it fetches data from a user-provided
> +        location, or "aggregate" if it groups all values in the
> +        subordinate sources that include the same ``stats_fs_value``.
> +        Values by default are considered to be cumulative, meaning the
> +        value they represent never decreases, but can also be defined as
> +        floating if they exibith a different behavior. The main difference

                            exhibit

> +        between these two is reflected into the file permission, since a
> +        floating value file does not allow the user to clear it. Each
> +        value has a ``stats_fs_type`` pointer in order to allow the user
> +        to provide custom get and clear functions. The library, however,
> +        also exports default ``stats_fs_type`` structs for the standard
> +        types (all unsigned and signed types plus boolean). A value can
> +        also provide a show function that takes care of displaying the
> +        value in a custom string format. This can be especially useful
> +        when displaying enums.
> +
> +Because stats_fs is a different mountpoint than debugfs, it is not affected
> +by security lockdown.
> +
> +Using Stats_fs
> +================
> +
> +Define a value::
> +
> +        struct statistics{
> +                uint64_t exit;
> +                ...
> +        };
> +
> +        struct kvm {
> +                ...
> +                struct statistics stat;
> +        };
> +
> +        struct stats_fs_value kvm_stats[] = {
> +                { "exit_vm", offsetof(struct kvm, stat.exit), &stats_fs_type_u64,
> +                  STATS_FS_SUM },
> +                { NULL }
> +        };
> +
> +The same ``struct stats_fs_value`` is used for both simple and aggregate
> +values, though the type and offset are only used for simple values.
> +Aggregates merge all values that use the same ``struct stats_fs_value``.
> +
> +Create the parent source::
> +
> +        struct stats_fs_source parent_source = stats_fs_source_create(0, "parent");
> +
> +Register it (files and folders
> +will only be visible after this function is called)::
> +
> +        stats_fs_source_register(parent_source);
> +
> +Create and add a child::
> +
> +        struct stats_fs_source child_source = stats_fs_source_create(STATS_FS_HIDDEN, "child");
> +
> +        stats_fs_source_add_subordinate(parent_source, child_source);
> +
> +The STATS_FS_HIDDEN attribute won't affect the aggregation, it will only
> +block the creation of the files.

Why does HIDDEN block the creation of files?  instead of their visibility?

> +
> +Add values to parent and child (also here order doesn't matter)::
> +
> +        struct kvm *base_ptr = kmalloc(..., sizeof(struct kvm));
> +        ...
> +        stats_fs_source_add_values(child_source, kvm_stats, base_ptr, 0);
> +        stats_fs_source_add_values(parent_source, kvm_stats, NULL, STATS_FS_HIDDEN);
> +
> +``child_source`` will be a simple value, since it has a non-NULL base
> +pointer, while ``parent_source`` will be an aggregate. During the adding
> +phase, also values can optionally be marked as hidden, so that the folder
> +and other values can be still shown.
> +
> +Of course the same ``struct stats_fs_value`` array can be also passed with a
> +different base pointer, to represent the same value but in another instance
> +of the kvm struct.
> +
> +Search:
> +
> +Fetch a value from the child source, returning the value
> +pointed by ``(uint64_t *) base_ptr + kvm_stats[0].offset``::
> +
> +        uint64_t ret_child, ret_parent;
> +
> +        stats_fs_source_get_value(child_source, &kvm_stats[0], &ret_child);
> +
> +Fetch an aggregate value, searching all subsources of ``parent_source`` for
> +the specified ``struct stats_fs_value``::
> +
> +        stats_fs_source_get_value(parent_source, &kvm_stats[0], &ret_parent);
> +
> +        assert(ret_child == ret_parent); // check expected result
> +
> +To make it more interesting, add another child::
> +
> +        struct stats_fs_source child_source2 = stats_fs_source_create(0, "child2");
> +
> +        stats_fs_source_add_subordinate(parent_source, child_source2);
> +        // now  the structure is parent -> child1
> +        //                              -> child2

Is that the same as                 parent -> child1 -> child2
?  It could almost be read as
                                    parent -> child1
                                    parent -> child2

Whichever it is, can you make it more explicit, please?


> +
> +        struct kvm *other_base_ptr = kmalloc(..., sizeof(struct kvm));
> +        ...
> +        stats_fs_source_add_values(child_source2, kvm_stats, other_base_ptr, 0);
> +
> +Note that other_base_ptr points to another instance of kvm, so the struct
> +stats_fs_value is the same but the address at which they point is not.
> +
> +Now get the aggregate value::
> +
> +        uint64_t ret_child, ret_child2, ret_parent;
> +
> +        stats_fs_source_get_value(child_source, &kvm_stats[0], &ret_child);
> +        stats_fs_source_get_value(parent_source, &kvm_stats[0], &ret_parent);
> +        stats_fs_source_get_value(child_source2, &kvm_stats[0], &ret_child2);
> +
> +        assert((ret_child + ret_child2) == ret_parent);
> +
> +Cleanup::
> +
> +        stats_fs_source_remove_subordinate(parent_source, child_source);
> +        stats_fs_source_revoke(child_source);
> +        stats_fs_source_put(child_source);
> +
> +        stats_fs_source_remove_subordinate(parent_source, child_source2);
> +        stats_fs_source_revoke(child_source2);
> +        stats_fs_source_put(child_source2);
> +
> +        stats_fs_source_put(parent_source);
> +        kfree(other_base_ptr);
> +        kfree(base_ptr);
> +
> +Calling stats_fs_source_revoke is very important, because it will ensure

           stats_fs_source_revoke()

> +that stats_fs will not access the data that were passed to
> +stats_fs_source_add_value for this source.
> +
> +Because open files increase the reference count for a stats_fs_source, the
> +source can end up living longer than the data that provides the values for
> +the source.  Calling stats_fs_source_revoke just before the backing data

                        stats_fs_source_revoke()

> +is freed avoids accesses to freed data structures. The sources will return
> +0.
> +
> +This is not needed for the parent_source, since it just contains
> +aggregates that would be 0 anyways if no matching child value exist.
> +
> +API Documentation
> +=================
> +
> +.. kernel-doc:: include/linux/stats_fs.h
> +   :export: fs/stats_fs/*.c
> \ No newline at end of file

Please fix that. ^^^^^


Thanks for the documentation.

-- 
~Randy

