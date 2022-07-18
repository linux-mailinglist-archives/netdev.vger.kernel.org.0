Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58C6578AF6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiGRTfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiGRTe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:34:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E072C10E
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:34:48 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id id17so641810wmb.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 12:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bCXO7jLaP7q7SAX58eiWinp4okViuMXlnXt6ZtGO6sI=;
        b=ZudZB4oprJBruUgObA00/Io5gesQ8NAZqMnW/6BM5G5JUVNpMJpCgDc3YaISdci7fV
         sV0qdseZ9IKFGi6yCDJqDp/NMhJOto4AsCkRL50B9bjeVspDL16u2YjNshBFTQAJIZpO
         RNahAVfnV7oJ1coHAN+ZCMNgc4OYcX90/m5AmbviyQfA/+P4XsEd8W1p1v3I2IJHwEoa
         rJLETLq2hKmxI7WL1N8WMd+iQb1uHM5k9itiWKa0jClAnqyZ98R2+qmlkjzvBlpWsxfu
         nZ2WdafKEYwrtwDN5QMmRy2m6qzkbrxtQjYOALIpwDntjgpJ91RsGHXiSv0zHiFgLcRW
         aiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bCXO7jLaP7q7SAX58eiWinp4okViuMXlnXt6ZtGO6sI=;
        b=QiAZYMAo/mllnCaclLy760DfSrhlvkpK5GyZvVENo57MrSeNvI/aIWeZBNAEpKgZaG
         /jQ8X1nmmbiLJsqmWbAG8Ll/IThKirxltuVBU+AQXMp2AVmbsGWv6QqUKHqhlrG/jcrm
         u2bKywBbAEuskr49IwwzKewuw7opAu05vq9ZEy48940LHwES4ubwakEUS3RbWzPmcxnl
         WxkzkTX2eZOpIFF9v4EbKVr62B05+73SmfijFLp63JKdmN50L2bvp8MOMrJg/wwCcHGY
         Yxy/Ml7dvhr+/tzjgBEvDcFpytrOTvOOE7Kmf68YXcGIH/DVANb7u08DutI+A7jn/mwx
         mHxg==
X-Gm-Message-State: AJIora9QDl+vwcVgo0in7YdVDfHSLKcmYJ5EO1ZcQTCoa6TWWVpoejfc
        rD9mYZxAJW+t5OjoP5y4RKGLXNcRQ0TsrkzH9UVIrQ==
X-Google-Smtp-Source: AGRyM1smD0KV10SRViSrEgcg3XtjPScGCVBtM2RIlQxQu6L136i8/j3q/R4kq/50bPwVpcvugur+BzkJ04SzhxWdMSg=
X-Received: by 2002:a05:600c:1e8e:b0:3a2:c1b4:922c with SMTP id
 be14-20020a05600c1e8e00b003a2c1b4922cmr27883098wmb.24.1658172887020; Mon, 18
 Jul 2022 12:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com> <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com> <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
In-Reply-To: <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Mon, 18 Jul 2022 12:34:10 -0700
Message-ID: <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e8d8db05e41975e6"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e8d8db05e41975e6
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 11, 2022 at 8:55 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 7/10/22 5:26 PM, Yonghong Song wrote:
> > >
> > >
> > > On 7/8/22 5:04 PM, Yosry Ahmed wrote:
> > >> Add a selftest that tests the whole workflow for collecting,
> > >> aggregating (flushing), and displaying cgroup hierarchical stats.
> > >>
> > >> TL;DR:
> > >> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
> > >>    in parts of it.
> > >> - Whenever reclaim happens, vmscan_start and vmscan_end update
> > >>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
> > >>    have updates.
> > >> - When userspace tries to read the stats, vmscan_dump calls rstat to
> > >> flush
> > >>    the stats, and outputs the stats in text format to userspace (similar
> > >>    to cgroupfs stats).
> > >> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
> > >>    updates, vmscan_flush aggregates cpu readings and propagates updates
> > >>    to parents.
> > >> - Userspace program makes sure the stats are aggregated and read
> > >>    correctly.
> > >>
> > >> Detailed explanation:
> > >> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
> > >>    measure the latency of cgroup reclaim. Per-cgroup readings are
> > >> stored in
> > >>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
> > >>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
> > >>    rstat updated tree on that cpu.
> > >>
> > >> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
> > >>    each cgroup. Reading this file invokes the program, which calls
> > >>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates
> > >> for all
> > >>    cpus and cgroups that have updates in this cgroup's subtree.
> > >> Afterwards,
> > >>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
> > >>    iteration early, so that we only expose stats for one cgroup per read.
> > >>
> > >> - An ftrace program, vmscan_flush, is also loaded and attached to
> > >>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is
> > >> invoked
> > >>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
> > >>    from the rstat tree in a bottom-up fashion, so calls will always be
> > >>    made for cgroups that have updates before their parents. The program
> > >>    aggregates percpu readings to a total per-cgroup reading, and also
> > >>    propagates them to the parent cgroup. After rstat flushing is over,
> > >> all
> > >>    cgroups will have correct updated hierarchical readings (including all
> > >>    cpus and all their descendants).
> > >>
> > >> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
> > >>    in parts of it, and makes sure that the stats collection, aggregation,
> > >>    and reading workflow works as expected.
> > >>
> > >> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > >> ---
> > >>   .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
> > >>   .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
> > >>   2 files changed, 597 insertions(+)
> > >>   create mode 100644
> > >> tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> > >>   create mode 100644
> > >> tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> > >>
> > > [...]
> > >> +
> > >> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long
> > >> cgroup_id,
> > >> +                          const char *file_name)
> > >> +{
> > >> +    char buf[128], path[128];
> > >> +    unsigned long long vmscan = 0, id = 0;
> > >> +    int err;
> > >> +
> > >> +    /* For every cgroup, read the file generated by cgroup_iter */
> > >> +    snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
> > >> +    err = read_from_file(path, buf, 128);
> > >> +    if (!ASSERT_OK(err, "read cgroup_iter"))
> > >> +        return 0;
> > >> +
> > >> +    /* Check the output file formatting */
> > >> +    ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
> > >> +             &id, &vmscan), 2, "output format");
> > >> +
> > >> +    /* Check that the cgroup_id is displayed correctly */
> > >> +    ASSERT_EQ(id, cgroup_id, "cgroup_id");
> > >> +    /* Check that the vmscan reading is non-zero */
> > >> +    ASSERT_GT(vmscan, 0, "vmscan_reading");
> > >> +    return vmscan;
> > >> +}
> > >> +
> > >> +static void check_vmscan_stats(void)
> > >> +{
> > >> +    int i;
> > >> +    unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
> > >> +
> > >> +    for (i = 0; i < N_CGROUPS; i++)
> > >> +        vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
> > >> +                                 cgroups[i].name);
> > >> +
> > >> +    /* Read stats for root too */
> > >> +    vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
> > >> +
> > >> +    /* Check that child1 == child1_1 + child1_2 */
> > >> +    ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] +
> > >> vmscan_readings[4],
> > >> +          "child1_vmscan");
> > >> +    /* Check that child2 == child2_1 + child2_2 */
> > >> +    ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] +
> > >> vmscan_readings[6],
> > >> +          "child2_vmscan");
> > >> +    /* Check that test == child1 + child2 */
> > >> +    ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] +
> > >> vmscan_readings[2],
> > >> +          "test_vmscan");
> > >> +    /* Check that root >= test */
> > >> +    ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
> > >
> > > I still get a test failure with
> > >
> > > get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> > > get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
> > > actual 0 <= expected 0
> > > check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0
> > > != expected -2
> > > check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0
> > > != expected -2
> > > check_vmscan_stats:PASS:test_vmscan 0 nsec
> > > check_vmscan_stats:PASS:root_vmscan 0 nsec
> > >
> > > I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
> > > and run this test (#33) and didn't get any stacktrace.
> > > But I do get stacktraces due to other operations like
> > >          try_to_free_mem_cgroup_pages+0x1fd [kernel]
> > >          try_to_free_mem_cgroup_pages+0x1fd [kernel]
> > >          memory_reclaim_write+0x88 [kernel]
> > >          cgroup_file_write+0x88 [kernel]
> > >          kernfs_fop_write_iter+0xd0 [kernel]
> > >          vfs_write+0x2c4 [kernel]
> > >          __x64_sys_write+0x60 [kernel]
> > >          do_syscall_64+0x2d [kernel]
> > >          entry_SYSCALL_64_after_hwframe+0x44 [kernel]
> > >
> > > If you can show me the stacktrace about how
> > > try_to_free_mem_cgroup_pages() is triggered in your setup, I can
> > > help debug this problem in my environment.
> >
> > BTW, CI also reported the test failure.
> > https://github.com/kernel-patches/bpf/pull/3284
> >
> > For example, with gcc built kernel,
> > https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
> >
> > The error:
> >
> >    get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> >    get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
> >    check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
> > actual 28390910 != expected 28390909
> >    check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
> > actual 0 != expected -2
> >    check_vmscan_stats:PASS:test_vmscan 0 nsec
> >    check_vmscan_stats:PASS:root_vmscan 0 nsec
> >
>
> Hey Yonghong,
>
> Thanks for helping us debug this failure. I can reproduce the CI
> failure in my enviornment, but this failure is actually different from
> the failure in your environment. In your environment it looks like no
> stats are gathered for all cgroups (either no reclaim happening or bpf
> progs not being run). In the CI and in my environment, only one cgroup
> observes this behavior.
>
> The thing is, I was able to reproduce the problem only when I ran all
> test_progs. When I run the selftest alone (test_progs -t
> cgroup_hierarchical_stats), it consistently passes, which is
> interesting.

I think I figured this one out (the CI failure). I set max_entries for
the maps in the test to 10, because I have 1 entry per-cgroup, and I
have less than 10 cgroups. When I run the test with other tests I
*think* there are other cgroups that are being created, so the number
exceeds 10, and some of the entries for the test cgroups cannot be
created. I saw a lot of "failed to create entry for cgroup.." message
in the bpf trace produced by my test, and the error turned out to be
-E2BIG. I increased max_entries to 100 and it seems to be consistently
passing when run with all the other tests, using both test_progs and
test_progs-no_alu32.

Please find a diff attached fixing this problem and a few other nits:
- Return meaningful exit codes from the reclaimer() child process and
check them in induce_vmscan().
- Make buf and path variables static in get_cgroup_vmscan_delay()
- Print error code in bpf trace when we fail to create a bpf map entry.
- Print 0 instead of -1 when we can't find a map entry, to avoid
underflowing the unsigned counters in the test.

Let me know if this diff works or not, and if I need to send a new
version with the diff or not. Also let me know if this fixes the
failures that you have been seeing locally (which looked different
from the CI failures).

Thanks!

>
> Anyway, one failure at a time :) I am working on debugging the CI
> failure (that occurs only when all tests are run), then we'll see if
> fixing that fixes the problem in our environment as well.
>
> If you have any pointers about why a test would consistently pass
> alone and consistently fail with others that would be good. Otherwise,
> I will keep you updated with any findings I reach.
>
> Thanks again!
>
> > >
> > >> +}
> > >> +
> > >> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj,
> > >> int cgroup_fd,
> > > [...]

--000000000000e8d8db05e41975e6
Content-Type: application/octet-stream; name="selftest_fix.patch"
Content-Disposition: attachment; filename="selftest_fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l5r59syo0>
X-Attachment-Id: f_l5r59syo0

ZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL2Nncm91
cF9oaWVyYXJjaGljYWxfc3RhdHMuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
X3Rlc3RzL2Nncm91cF9oaWVyYXJjaGljYWxfc3RhdHMuYwppbmRleCA1ZDBhOGJiMTEwYTQuLmUw
MWZhYzQwMWVjNSAxMDA2NDQKLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2df
dGVzdHMvY2dyb3VwX2hpZXJhcmNoaWNhbF9zdGF0cy5jCisrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2JwZi9wcm9nX3Rlc3RzL2Nncm91cF9oaWVyYXJjaGljYWxfc3RhdHMuYwpAQCAtMTU1
LDI4ICsxNTUsMzAgQEAgc3RhdGljIHZvaWQgcmVjbGFpbWVyKGNvbnN0IGNoYXIgKmNncm91cF9w
YXRoLCBzaXplX3Qgc2l6ZSkKIAlpbnQgZXJyOwogCiAJLyogSm9pbiBjZ3JvdXAgaW4gdGhlIHBh
cmVudCBwcm9jZXNzIHdvcmtkaXIgKi8KLQlqb2luX3BhcmVudF9jZ3JvdXAoY2dyb3VwX3BhdGgp
OworCWlmIChqb2luX3BhcmVudF9jZ3JvdXAoY2dyb3VwX3BhdGgpKQorCQlleGl0KEVBQ0NFUyk7
CiAKIAkvKiBBbGxvY2F0ZSBtZW1vcnkgKi8KIAlidWYgPSBtYWxsb2Moc2l6ZSk7CisJaWYoIWJ1
ZikKKwkJZXhpdChFTk9NRU0pOworCisJLyogV3JpdGUgdG8gbWVtb3J5IHRvIG1ha2Ugc3VyZSBp
dCdzIGFjdHVhbGx5IGFsbG9jYXRlZCAqLwogCWZvciAocHRyID0gYnVmOyBwdHIgPCBidWYgKyBz
aXplOyBwdHIgKz0gUEFHRV9TSVpFKQogCQkqcHRyID0gMTsKIAotCS8qCi0JICogVHJ5IHRvIHJl
Y2xhaW0gbWVtb3J5LgotCSAqIG1lbW9yeS5yZWNsYWltIGNhbiByZXR1cm4gRUFHQUlOIGlmIHRo
ZSBhbW91bnQgaXMgbm90Ci0JICogZnVsbHkgcmVjbGFpbWVkLgotCSAqLworCS8qIFRyeSB0byBy
ZWNsYWltIG1lbW9yeSAqLwogCXNucHJpbnRmKHNpemVfYnVmLCAxMjgsICIlbHUiLCBzaXplKTsK
IAllcnIgPSB3cml0ZV9jZ3JvdXBfZmlsZV9wYXJlbnQoY2dyb3VwX3BhdGgsICJtZW1vcnkucmVj
bGFpbSIsIHNpemVfYnVmKTsKIAogCWZyZWUoYnVmKTsKLQlleGl0KGVyciAmJiBlcnJubyAhPSBF
QUdBSU4pOworCS8qIG1lbW9yeS5yZWNsYWltIHJldHVybnMgRUFHQUlOIGlmIHRoZSBhbW91bnQg
aXMgbm90IGZ1bGx5IHJlY2xhaW1lZCAqLworCWV4aXQoZXJyICYmIGVycm5vICE9IEVBR0FJTiA/
IGVycm5vIDogMCk7CiB9CiAKIHN0YXRpYyBpbnQgaW5kdWNlX3Ztc2Nhbih2b2lkKQogewotCWlu
dCBpLCBzdGF0dXMsIGVyciA9IDA7CisJaW50IGksIHN0YXR1czsKIAogCS8qCiAJICogSW4gZXZl
cnkgbGVhZiBjZ3JvdXAsIHJ1biBhIGNoaWxkIHByb2Nlc3MgdGhhdCBhbGxvY2F0ZXMgc29tZSBt
ZW1vcnkKQEAgLTE4OSwxMyArMTkxLDEzIEBAIHN0YXRpYyBpbnQgaW5kdWNlX3Ztc2Nhbih2b2lk
KQogCQlwaWQgPSBmb3JrKCk7CiAJCWlmIChwaWQgPT0gMCkKIAkJCXJlY2xhaW1lcihjZ3JvdXBz
W2ldLnBhdGgsIE1CKDUpKTsKLQkJaWYgKCFBU1NFUlRfR1QocGlkLCAwLCAiZm9yayByZWNsYWlt
ZXIgY2hpbGQiKSkKKwkJaWYgKCFBU1NFUlRfR1QocGlkLCAwLCAiZm9yayByZWNsYWltZXIiKSkK
IAkJCXJldHVybiBwaWQ7CiAKIAkJLyogQ2xlYW51cCByZWNsYWltZXIgY2hpbGQgKi8KIAkJd2Fp
dHBpZChwaWQsICZzdGF0dXMsIDApOwotCQllcnIgPSAhV0lGRVhJVEVEKHN0YXR1cykgfHwgV0VY
SVRTVEFUVVMoc3RhdHVzKTsKLQkJQVNTRVJUX09LKGVyciwgInJlY2xhaW1lciBjaGlsZCBleGl0
IHN0YXR1cyIpOworCQlBU1NFUlRfVFJVRShXSUZFWElURUQoc3RhdHVzKSwgInJlY2xhaW1lciBl
eGl0ZWQiKTsKKwkJQVNTRVJUX0VRKFdFWElUU1RBVFVTKHN0YXR1cyksIDAsICJyZWNsYWltIGV4
aXQgY29kZSIpOwogCX0KIAlyZXR1cm4gMDsKIH0KQEAgLTIwMyw3ICsyMDUsNyBAQCBzdGF0aWMg
aW50IGluZHVjZV92bXNjYW4odm9pZCkKIHN0YXRpYyB1bnNpZ25lZCBsb25nIGxvbmcgZ2V0X2Nn
cm91cF92bXNjYW5fZGVsYXkodW5zaWduZWQgbG9uZyBsb25nIGNncm91cF9pZCwKIAkJCQkJCSAg
Y29uc3QgY2hhciAqZmlsZV9uYW1lKQogewotCWNoYXIgYnVmWzEyOF0sIHBhdGhbMTI4XTsKKwlz
dGF0aWMgY2hhciBidWZbMTI4XSwgcGF0aFsxMjhdOwogCXVuc2lnbmVkIGxvbmcgbG9uZyB2bXNj
YW4gPSAwLCBpZCA9IDA7CiAJaW50IGVycjsKIApkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL3Byb2dzL2Nncm91cF9oaWVyYXJjaGljYWxfc3RhdHMuYyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9jZ3JvdXBfaGllcmFyY2hpY2FsX3N0YXRzLmMKaW5k
ZXggMGExYTNiZWJkZjRjLi44NWE2NWE3MjQ4MmUgMTAwNjQ0Ci0tLSBhL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi9wcm9ncy9jZ3JvdXBfaGllcmFyY2hpY2FsX3N0YXRzLmMKKysrIGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2Nncm91cF9oaWVyYXJjaGljYWxfc3RhdHMu
YwpAQCAtMzcsMTQgKzM3LDE0IEBAIHN0cnVjdCB2bXNjYW4gewogCiBzdHJ1Y3QgewogCV9fdWlu
dCh0eXBlLCBCUEZfTUFQX1RZUEVfUEVSQ1BVX0hBU0gpOwotCV9fdWludChtYXhfZW50cmllcywg
MTApOworCV9fdWludChtYXhfZW50cmllcywgMTAwKTsKIAlfX3R5cGUoa2V5LCBfX3U2NCk7CiAJ
X190eXBlKHZhbHVlLCBzdHJ1Y3Qgdm1zY2FuX3BlcmNwdSk7CiB9IHBjcHVfY2dyb3VwX3Ztc2Nh
bl9lbGFwc2VkIFNFQygiLm1hcHMiKTsKIAogc3RydWN0IHsKIAlfX3VpbnQodHlwZSwgQlBGX01B
UF9UWVBFX0hBU0gpOwotCV9fdWludChtYXhfZW50cmllcywgMTApOworCV9fdWludChtYXhfZW50
cmllcywgMTAwKTsKIAlfX3R5cGUoa2V5LCBfX3U2NCk7CiAJX190eXBlKHZhbHVlLCBzdHJ1Y3Qg
dm1zY2FuKTsKIH0gY2dyb3VwX3Ztc2Nhbl9lbGFwc2VkIFNFQygiLm1hcHMiKTsKQEAgLTY1LDEx
ICs2NSwxMyBAQCBzdGF0aWMgaW5saW5lIHVpbnQ2NF90IGNncm91cF9pZChzdHJ1Y3QgY2dyb3Vw
ICpjZ3JwKQogc3RhdGljIGlubGluZSBpbnQgY3JlYXRlX3Ztc2Nhbl9wZXJjcHVfZWxlbShfX3U2
NCBjZ19pZCwgX191NjQgc3RhdGUpCiB7CiAJc3RydWN0IHZtc2Nhbl9wZXJjcHUgcGNwdV9pbml0
ID0gey5zdGF0ZSA9IHN0YXRlLCAucHJldiA9IDB9OworCWludCBlcnI7CiAKLQlpZiAoYnBmX21h
cF91cGRhdGVfZWxlbSgmcGNwdV9jZ3JvdXBfdm1zY2FuX2VsYXBzZWQsICZjZ19pZCwKLQkJCQkm
cGNwdV9pbml0LCBCUEZfTk9FWElTVCkpIHsKLQkJYnBmX3ByaW50aygiZmFpbGVkIHRvIGNyZWF0
ZSBwY3B1IGVudHJ5IGZvciBjZ3JvdXAgJWxsdVxuIgotCQkJICAgLCBjZ19pZCk7CisJZXJyID0g
YnBmX21hcF91cGRhdGVfZWxlbSgmcGNwdV9jZ3JvdXBfdm1zY2FuX2VsYXBzZWQsICZjZ19pZCwK
KwkJCQkgICZwY3B1X2luaXQsIEJQRl9OT0VYSVNUKTsKKwlpZiAoZXJyKSB7CisJCWJwZl9wcmlu
dGsoImZhaWxlZCB0byBjcmVhdGUgcGNwdSBlbnRyeSBmb3IgY2dyb3VwICVsbHU6ICVkXG4iCisJ
CQkgICAsIGNnX2lkLCBlcnIpOwogCQlyZXR1cm4gMTsKIAl9CiAJcmV0dXJuIDA7CkBAIC03OCwx
MSArODAsMTMgQEAgc3RhdGljIGlubGluZSBpbnQgY3JlYXRlX3Ztc2Nhbl9wZXJjcHVfZWxlbShf
X3U2NCBjZ19pZCwgX191NjQgc3RhdGUpCiBzdGF0aWMgaW5saW5lIGludCBjcmVhdGVfdm1zY2Fu
X2VsZW0oX191NjQgY2dfaWQsIF9fdTY0IHN0YXRlLCBfX3U2NCBwZW5kaW5nKQogewogCXN0cnVj
dCB2bXNjYW4gaW5pdCA9IHsuc3RhdGUgPSBzdGF0ZSwgLnBlbmRpbmcgPSBwZW5kaW5nfTsKKwlp
bnQgZXJyOwogCi0JaWYgKGJwZl9tYXBfdXBkYXRlX2VsZW0oJmNncm91cF92bXNjYW5fZWxhcHNl
ZCwgJmNnX2lkLAotCQkJCSZpbml0LCBCUEZfTk9FWElTVCkpIHsKLQkJYnBmX3ByaW50aygiZmFp
bGVkIHRvIGNyZWF0ZSBlbnRyeSBmb3IgY2dyb3VwICVsbHVcbiIKLQkJCSAgICwgY2dfaWQpOwor
CWVyciA9IGJwZl9tYXBfdXBkYXRlX2VsZW0oJmNncm91cF92bXNjYW5fZWxhcHNlZCwgJmNnX2lk
LAorCQkJCSAgJmluaXQsIEJQRl9OT0VYSVNUKTsKKwlpZiAoZXJyKSB7CisJCWJwZl9wcmludGso
ImZhaWxlZCB0byBjcmVhdGUgZW50cnkgZm9yIGNncm91cCAlbGx1OiAlZFxuIgorCQkJICAgLCBj
Z19pZCwgZXJyKTsKIAkJcmV0dXJuIDE7CiAJfQogCXJldHVybiAwOwpAQCAtMjIwLDcgKzIyNCw3
IEBAIGludCBCUEZfUFJPRyhkdW1wX3Ztc2Nhbiwgc3RydWN0IGJwZl9pdGVyX21ldGEgKm1ldGEs
IHN0cnVjdCBjZ3JvdXAgKmNncnApCiAJdG90YWxfc3RhdCA9IGJwZl9tYXBfbG9va3VwX2VsZW0o
JmNncm91cF92bXNjYW5fZWxhcHNlZCwgJmNnX2lkKTsKIAlpZiAoIXRvdGFsX3N0YXQpIHsKIAkJ
YnBmX3ByaW50aygiZXJyb3IgZmluZGluZyBzdGF0cyBmb3IgY2dyb3VwICVsbHVcbiIsIGNnX2lk
KTsKLQkJQlBGX1NFUV9QUklOVEYoc2VxLCAiY2dfaWQ6ICVsbHUsIHRvdGFsX3Ztc2Nhbl9kZWxh
eTogLTFcbiIsCisJCUJQRl9TRVFfUFJJTlRGKHNlcSwgImNnX2lkOiAlbGx1LCB0b3RhbF92bXNj
YW5fZGVsYXk6IDBcbiIsCiAJCQkgICAgICAgY2dfaWQpOwogCQlyZXR1cm4gMTsKIAl9Cg==
--000000000000e8d8db05e41975e6--
